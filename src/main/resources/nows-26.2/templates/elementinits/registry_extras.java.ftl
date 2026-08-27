package ${package}.init;

import net.minecraft.core.particles.SimpleParticleType;
import net.minecraft.sounds.SoundEvent;
import net.minecraft.world.effect.MobEffect;
import net.minecraft.world.effect.MobEffectCategory;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.item.BucketItem;
import net.minecraft.world.item.alchemy.Potion;
import net.minecraft.world.level.material.Fluid;
import space.nows.mc.api.registry.RegistryApi;

public final class ${JavaModName}RegistryExtras {
    private ${JavaModName}RegistryExtras() {
    }

    public static void register(RegistryApi registries) {
    }

    public static SoundEvent sound(RegistryApi registries, String path) {
        return registries.registerVariableRangeSound(${JavaModName}Resources.id(path));
    }

    public static SoundEvent fixedSound(RegistryApi registries, String path, float range) {
        return registries.registerFixedRangeSound(${JavaModName}Resources.id(path), range);
    }

    public static MobEffect simpleEffect(RegistryApi registries, String path, MobEffectCategory category, int color) {
        return registries.registerSimpleMobEffect(${JavaModName}Resources.id(path), category, color);
    }

    public static Potion potion(RegistryApi registries, String path, MobEffectInstance... effects) {
        return registries.registerPotion(${JavaModName}Resources.id(path), effects);
    }

    public static Attribute rangedAttribute(
            RegistryApi registries,
            String path,
            double defaultValue,
            double minValue,
            double maxValue
    ) {
        return registries.registerRangedAttribute(
                ${JavaModName}Resources.id(path),
                "attribute.name.${modid}." + path.replace(':', '.').replace('/', '.'),
                defaultValue,
                minValue,
                maxValue);
    }

    public static SimpleParticleType simpleParticle(RegistryApi registries, String path) {
        return registries.registerSimpleParticleType(${JavaModName}Resources.id(path), false);
    }

    public static Fluid fluid(RegistryApi registries, String path, Fluid fluid) {
        return registries.registerFluid(${JavaModName}Resources.id(path), fluid);
    }

    public static BucketItem bucket(RegistryApi registries, String path, Fluid fluid) {
        return registries.registerBucketItem(${JavaModName}Resources.id(path), fluid);
    }

    public static <T extends Entity> EntityType<T> entity(
            RegistryApi registries,
            String path,
            EntityType.EntityFactory<T> factory,
            MobCategory category,
            float width,
            float height
    ) {
        return registries.registerEntityType(${JavaModName}Resources.id(path), factory, category, width, height);
    }
}
