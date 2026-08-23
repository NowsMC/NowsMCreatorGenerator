package ${package}.procedures;

import reactor.util.Logger;
import space.nows.integration.logging.NowsLog;

public final class ${name}Procedure {
    private static final Logger LOG = NowsLog.get(${name}Procedure.class);

    private ${name}Procedure() {
    }

    public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(<#list dependencies as d>${d.getType(generator.getWorkspace())} ${d.getName()}<#sep>, </#list>) {
<#if localvariables??>
<#list localvariables as var>
        <@var.getType().getScopeDefinition(generator.getWorkspace(), "LOCAL")['init']?interpret/>
</#list>
</#if>
        ${procedurecode}
<#if return_type??>
        return ${return_type.getDefaultValue(generator.getWorkspace())};
</#if>
    }

    static Logger log() {
        return LOG;
    }
}
