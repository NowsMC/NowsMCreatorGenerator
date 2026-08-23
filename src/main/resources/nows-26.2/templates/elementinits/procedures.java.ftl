package ${package}.init;

public final class ${JavaModName}Procedures {
    private ${JavaModName}Procedures() {
    }

    public static void register() {
<#list procedures as procedure>
<#if !procedure.procedurexml?contains('no_ext_trigger')>
        ${package}.procedures.${procedure.getModElement().getName()}Procedure.class.getName();
</#if>
</#list>
    }
}
