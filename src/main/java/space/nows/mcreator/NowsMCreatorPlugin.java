package space.nows.mcreator;

import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;

import javax.swing.AbstractButton;
import javax.swing.ButtonGroup;
import javax.swing.ComboBoxModel;
import javax.swing.DefaultButtonModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRootPane;
import javax.swing.JToggleButton;
import javax.swing.SwingUtilities;
import java.awt.AWTEvent;
import java.awt.CardLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.EventQueue;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.event.AWTEventListener;
import java.awt.event.ActionListener;
import java.awt.event.MouseListener;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * MCreator 2026.2 compatibility integration for the Nows generator.
 *
 * <p>MCreator currently hard-codes workspace categories and GeneratorFlavor as
 * an enum. The Nows generator therefore stays FABRIC-compatible internally,
 * while this Java plugin adds a dedicated Nows workspace card in the create
 * workspace dialog. This keeps one installable plugin ZIP and avoids exposing
 * Nows as a Fabric choice to users.</p>
 */
public final class NowsMCreatorPlugin extends JavaPlugin {
    private static final Logger LOG = Logger.getLogger(NowsMCreatorPlugin.class.getName());

    private static final String NEW_WORKSPACE_DIALOG =
            "net.mcreator.ui.dialogs.workspace.NewWorkspaceDialog";
    private static final String FABRIC_WORKSPACE_PANEL =
            "net.mcreator.ui.dialogs.workspace.FabricWorkspacePanel";
    private static final String PATCH_MARKER =
            "space.nows.mcreator.workspace-type-installed";

    private final AWTEventListener windowListener = this::handleAwtEvent;

    public NowsMCreatorPlugin(Plugin plugin) {
        super(plugin);

        Toolkit.getDefaultToolkit().addAWTEventListener(
                windowListener, AWTEvent.WINDOW_EVENT_MASK);

        // Also cover a dialog that happened to be opened during plugin startup.
        EventQueue.invokeLater(() -> {
            for (Window window : Window.getWindows()) {
                tryInstall(window);
            }
        });

        LOG.info("Nows MCreator Java integration loaded");
    }

    private void handleAwtEvent(AWTEvent event) {
        if (event instanceof WindowEvent windowEvent
                && windowEvent.getID() == WindowEvent.WINDOW_OPENED) {
            Window window = windowEvent.getWindow();
            SwingUtilities.invokeLater(() -> tryInstall(window));
        }
    }

    private void tryInstall(Window window) {
        if (window == null || !NEW_WORKSPACE_DIALOG.equals(window.getClass().getName())) {
            return;
        }

        JRootPane rootPane = rootPaneOf(window);
        if (rootPane != null && Boolean.TRUE.equals(rootPane.getClientProperty(PATCH_MARKER))) {
            return;
        }

        try {
            if (installNowsWorkspaceType(window) && rootPane != null) {
                rootPane.putClientProperty(PATCH_MARKER, Boolean.TRUE);
            }
        } catch (ReflectiveOperationException | RuntimeException exception) {
            LOG.log(Level.SEVERE,
                    "Could not install the Nows workspace type into MCreator 2026.2", exception);
        }
    }

    private boolean installNowsWorkspaceType(Window dialog) throws ReflectiveOperationException {
        Class<?> dialogClass = dialog.getClass();

        JToggleButton fabricButton = (JToggleButton) getField(dialog, "fabric");
        JToggleButton quiltButton = (JToggleButton) getField(dialog, "quilt");
        JPanel workspacePanels = (JPanel) getField(dialog, "workspacePanels");
        CardLayout cardLayout = (CardLayout) getField(dialog, "cardLayout");

        Object nowsWorkspacePanel = createFabricCompatibleWorkspacePanel(dialog);
        JPanel nowsContainer = (JPanel) invokeNoArg(nowsWorkspacePanel, "getContainer");

        JComboBox<Object> nowsGeneratorCombo = findGeneratorCombo(nowsContainer);
        if (nowsGeneratorCombo == null) {
            LOG.warning("Nows integration: generator combo box was not found");
            return false;
        }

        List<Object> allFabricGenerators = comboItems(nowsGeneratorCombo);
        List<Object> nowsGenerators = matching(allFabricGenerators, true);
        if (nowsGenerators.isEmpty()) {
            LOG.warning("Nows integration: no packaged Nows generator was found");
            return false;
        }

        // Give Nows its own independent form/card, then narrow its generator
        // selector to Nows versions only.
        workspacePanels.add(nowsContainer, "nows");
        replaceComboItems(nowsGeneratorCombo, nowsGenerators);
        installFilteredGeneratorChooser(dialog, nowsGeneratorCombo, nowsGenerators, "Nows");
        replaceFabricLabelsWithNows(nowsContainer);

        // Nows is internally FABRIC-flavored for MCreator compatibility. Remove
        // it from the actual Fabric card so it is not presented twice.
        AbstractButton selectedBefore = selectedButton(fabricButton);
        cardLayout.show(workspacePanels, "fabric");
        Component fabricContainer = visibleCard(workspacePanels);
        if (fabricContainer instanceof Container fabricCard) {
            JComboBox<Object> fabricGeneratorCombo = findGeneratorCombo(fabricCard);
            if (fabricGeneratorCombo != null) {
                List<Object> fabricGenerators = matching(comboItems(fabricGeneratorCombo), false);
                replaceComboItems(fabricGeneratorCombo, fabricGenerators);
                installFilteredGeneratorChooser(dialog, fabricGeneratorCombo, fabricGenerators, "Fabric");

                if (fabricGenerators.isEmpty()) {
                    fabricButton.setEnabled(false);
                    fabricButton.setToolTipText("No Fabric generator is installed. Nows has its own workspace type.");
                }
            }
        }

        JToggleButton nowsButton = new JToggleButton("Nows mod", nows16Icon());
        invokePrivate(dialog, "styleButton", new Class<?>[] { JToggleButton.class }, nowsButton);

        ButtonGroup group = buttonGroupOf(fabricButton);
        if (group != null) {
            group.add(nowsButton);
        }

        Container workspaceType = quiltButton.getParent();
        int insertIndex = indexOf(workspaceType, quiltButton);
        workspaceType.add(nowsButton, Math.max(0, insertIndex + 1));

        nowsButton.addActionListener(event -> {
            try {
                setField(dialog, "current", nowsWorkspacePanel);
                cardLayout.show(workspacePanels, "nows");
                invokeNoArgIfPresent(nowsWorkspacePanel, "focusMainField");
            } catch (ReflectiveOperationException exception) {
                LOG.log(Level.SEVERE, "Could not switch to the Nows workspace card", exception);
            }
        });

        // Restore whatever MCreator selected before we inspected the Fabric card.
        if (selectedBefore != null && selectedBefore.isEnabled()) {
            selectedBefore.doClick();
        }

        workspaceType.revalidate();
        workspaceType.repaint();
        workspacePanels.revalidate();
        workspacePanels.repaint();

        // Adding one row after the dialog has already been packed may require a
        // little extra vertical room, but never shrink a user-visible dialog.
        dialog.validate();
        int requiredHeight = dialog.getPreferredSize().height;
        if (requiredHeight > dialog.getHeight()) {
            dialog.setSize(dialog.getWidth(), requiredHeight);
        }

        LOG.info("Installed dedicated Nows workspace type in MCreator create-workspace dialog");
        return true;
    }

    private Object createFabricCompatibleWorkspacePanel(Window parent)
            throws ReflectiveOperationException {
        ClassLoader loader = parent.getClass().getClassLoader();
        Class<?> panelClass = Class.forName(FABRIC_WORKSPACE_PANEL, true, loader);
        Constructor<?> constructor = panelClass.getConstructor(Window.class);
        return constructor.newInstance(parent);
    }

    @SuppressWarnings("unchecked")
    private static JComboBox<Object> findGeneratorCombo(Container root) {
        for (Component component : root.getComponents()) {
            if (component instanceof JComboBox<?> comboBox) {
                ComboBoxModel<?> model = comboBox.getModel();
                if (model.getSize() == 0 || looksLikeGeneratorConfiguration(model.getElementAt(0))) {
                    return (JComboBox<Object>) comboBox;
                }
            }
            if (component instanceof Container container) {
                JComboBox<Object> nested = findGeneratorCombo(container);
                if (nested != null) {
                    return nested;
                }
            }
        }
        return null;
    }

    private static boolean looksLikeGeneratorConfiguration(Object object) {
        if (object == null) {
            return true;
        }
        try {
            object.getClass().getMethod("getGeneratorName");
            return true;
        } catch (NoSuchMethodException ignored) {
            return false;
        }
    }

    private static List<Object> comboItems(JComboBox<Object> combo) {
        List<Object> items = new ArrayList<>();
        for (int index = 0; index < combo.getItemCount(); index++) {
            items.add(combo.getItemAt(index));
        }
        return items;
    }

    private static List<Object> matching(List<Object> generators, boolean nows) {
        List<Object> result = new ArrayList<>();
        for (Object generator : generators) {
            if (isNowsGenerator(generator) == nows) {
                result.add(generator);
            }
        }
        return result;
    }

    private static void replaceComboItems(JComboBox<Object> combo, List<Object> items) {
        combo.removeAllItems();
        for (Object item : items) {
            combo.addItem(item);
        }
        if (!items.isEmpty()) {
            combo.setSelectedIndex(0);
        }
    }

    private static boolean isNowsGenerator(Object generator) {
        if (generator == null) {
            return false;
        }

        try {
            Method method = generator.getClass().getMethod("getGeneratorName");
            Object value = method.invoke(generator);
            if (value != null) {
                String name = value.toString().toLowerCase(Locale.ROOT);
                // Packaged by build.gradle.kts as fabric-<mc-version>-nows.
                if (name.startsWith("fabric-") && name.endsWith("-nows")) {
                    return true;
                }
            }
        } catch (ReflectiveOperationException ignored) {
            // Fall through to the readable-name check for forward compatibility.
        }

        return generator.toString().toLowerCase(Locale.ROOT).startsWith("nows for ");
    }

    private static void installFilteredGeneratorChooser(
            Window parent,
            JComboBox<Object> combo,
            List<Object> choices,
            String familyName) {
        JButton editButton = findNearestButton(combo);
        if (editButton != null) {
            for (ActionListener listener : editButton.getActionListeners()) {
                editButton.removeActionListener(listener);
            }
            editButton.setEnabled(!choices.isEmpty());
            editButton.addActionListener(event -> showFilteredChooser(parent, combo, choices, familyName));
        }

        // WorkspaceDialogs installs a mouse shortcut on the disabled combo box.
        // Remove only MCreator's selector listener; keep Look&Feel listeners.
        for (MouseListener listener : combo.getMouseListeners()) {
            if (listener.getClass().getName().contains("WorkspaceDialogs$WorkspaceDialogPanel")) {
                combo.removeMouseListener(listener);
            }
        }
    }

    private static void showFilteredChooser(
            Window parent,
            JComboBox<Object> combo,
            List<Object> choices,
            String familyName) {
        if (choices.isEmpty()) {
            return;
        }

        Object current = combo.getSelectedItem();
        Object selected = JOptionPane.showInputDialog(
                parent,
                "Select " + familyName + " generator:",
                "Generator selector",
                JOptionPane.PLAIN_MESSAGE,
                null,
                choices.toArray(),
                current != null ? current : choices.get(0));

        if (selected != null) {
            combo.setSelectedItem(selected);
        }
    }

    private static JButton findNearestButton(Component component) {
        Container ancestor = component.getParent();
        for (int depth = 0; ancestor != null && depth < 4; depth++, ancestor = ancestor.getParent()) {
            JButton button = firstButtonBelow(ancestor, component);
            if (button != null) {
                return button;
            }
        }
        return null;
    }

    private static JButton firstButtonBelow(Container root, Component excludedBranch) {
        for (Component component : root.getComponents()) {
            if (component == excludedBranch) {
                continue;
            }
            if (component instanceof JButton button) {
                return button;
            }
            if (component instanceof Container container) {
                JButton nested = firstButtonBelow(container, excludedBranch);
                if (nested != null) {
                    return nested;
                }
            }
        }
        return null;
    }

    private static void replaceFabricLabelsWithNows(Container root) {
        for (Component component : root.getComponents()) {
            if (component instanceof JLabel label && label.getText() != null) {
                String text = label.getText();
                text = text.replace("Fabric", "Nows");
                text = text.replace("fabric", "Nows");
                label.setText(text);
            }
            if (component instanceof JComponent jc && jc.getToolTipText() != null) {
                String tooltip = jc.getToolTipText()
                        .replace("Fabric", "Nows")
                        .replace("fabric", "Nows");
                jc.setToolTipText(tooltip);
            }
            if (component instanceof Container container) {
                replaceFabricLabelsWithNows(container);
            }
        }
    }

    private static AbstractButton selectedButton(JToggleButton button) {
        ButtonGroup group = buttonGroupOf(button);
        if (group == null || group.getSelection() == null) {
            return null;
        }
        for (var buttons = group.getElements(); buttons.hasMoreElements();) {
            AbstractButton candidate = buttons.nextElement();
            if (candidate.getModel() == group.getSelection()) {
                return candidate;
            }
        }
        return null;
    }

    private static ButtonGroup buttonGroupOf(AbstractButton button) {
        if (button.getModel() instanceof DefaultButtonModel model) {
            return model.getGroup();
        }
        return null;
    }

    private static Component visibleCard(JPanel cardPanel) {
        for (Component component : cardPanel.getComponents()) {
            if (component.isVisible()) {
                return component;
            }
        }
        return null;
    }

    private static int indexOf(Container parent, Component child) {
        Component[] components = parent.getComponents();
        for (int index = 0; index < components.length; index++) {
            if (components[index] == child) {
                return index;
            }
        }
        return components.length - 1;
    }

    private static ImageIcon nows16Icon() {
        var resource = NowsMCreatorPlugin.class.getResource("/icons/nows-16.png");
        if (resource != null) {
            return new ImageIcon(resource);
        }
        LOG.warning("Nows integration: bundled Nows icon was not found");
        return transparent16Icon();
    }

    private static ImageIcon transparent16Icon() {
        BufferedImage image = new BufferedImage(16, 16, BufferedImage.TYPE_INT_ARGB);
        // Touch the image through Graphics2D so every JVM/LAF sees a realized icon.
        Graphics2D graphics = image.createGraphics();
        graphics.dispose();
        Image scaled = image.getScaledInstance(16, 16, Image.SCALE_DEFAULT);
        return new ImageIcon(scaled);
    }

    private static JRootPane rootPaneOf(Window window) {
        if (window instanceof javax.swing.RootPaneContainer rootPaneContainer) {
            return rootPaneContainer.getRootPane();
        }
        return null;
    }

    private static Object getField(Object target, String name) throws ReflectiveOperationException {
        Field field = findField(target.getClass(), name);
        field.setAccessible(true);
        return field.get(target);
    }

    private static void setField(Object target, String name, Object value)
            throws ReflectiveOperationException {
        Field field = findField(target.getClass(), name);
        field.setAccessible(true);
        field.set(target, value);
    }

    private static Field findField(Class<?> type, String name) throws NoSuchFieldException {
        Class<?> current = type;
        while (current != null) {
            try {
                return current.getDeclaredField(name);
            } catch (NoSuchFieldException ignored) {
                current = current.getSuperclass();
            }
        }
        throw new NoSuchFieldException(type.getName() + "." + name);
    }

    private static Object invokeNoArg(Object target, String name)
            throws ReflectiveOperationException {
        Method method = findMethod(target.getClass(), name);
        method.setAccessible(true);
        return method.invoke(target);
    }

    private static void invokeNoArgIfPresent(Object target, String name) {
        try {
            invokeNoArg(target, name);
        } catch (ReflectiveOperationException ignored) {
            // Cosmetic only; focus behavior is allowed to vary between MCreator builds.
        }
    }

    private static Method findMethod(Class<?> type, String name, Class<?>... parameterTypes)
            throws NoSuchMethodException {
        Class<?> current = type;
        while (current != null) {
            try {
                return current.getDeclaredMethod(name, parameterTypes);
            } catch (NoSuchMethodException ignored) {
                current = current.getSuperclass();
            }
        }
        throw new NoSuchMethodException(type.getName() + "." + name);
    }

    private static Object invokePrivate(
            Object target,
            String name,
            Class<?>[] parameterTypes,
            Object... args) throws ReflectiveOperationException {
        Method method = findMethod(target.getClass(), name, parameterTypes);
        method.setAccessible(true);
        return method.invoke(target, args);
    }
}
