{% macro learn_variables() %}
    {# There are 2 types of variables jinja and dbt #}
    
    {# Example jinja variables #}
    {% set your_name_jinja = "someone" %}
    {# concat in jinja with a ~ sign #}
    
    {{ log(
        "Hello " ~ your_name_jinja,
        info = True
    ) }}

    {# dbt variables are also known as project variables. #}

    {{ log( "Hello " ~ var("user_name") ~ "!", info=True) }}
    {# run with dbt run-operation learn_variables --vars '{user_name: dbtProjectVar_someone}' #}
{% endmacro %}
