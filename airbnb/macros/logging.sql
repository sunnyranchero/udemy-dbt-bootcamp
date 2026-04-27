{% macro learn_logging() %}
    {{ log(
        "Logging something other than what would normally be logged.",
        info = True
    ) }}
{% endmacro %}
