# ------------------------------------------------------------------------------
# lib
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# widgets
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# models
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# views
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------

$ ->
    $cmJson = $(".cm-json")
    $cmMustache = $(".cm-mustache")

    cmMustache = CodeMirror $("#mustache")[0],
        value: window.templateMustache
        mode:  
            name: "xml"
        lineNumbers: true
        theme: "lesser-dark"
        lineNumbers: true
        tabSize: 2
        smartIndent: false


    cmJson = CodeMirror $("#json")[0],
        value: window.templateJson
        mode:  
            name: "javascript"
        theme: "lesser-dark"
        lineNumbers: true
        tabSize: 2
        smartIndent: false

    cmOutput = CodeMirror $("#output")[0],
        value: "<output></output>"
        mode:  
            name: "xml"
        theme: "lesser-dark"
        lineNumbers: true
        tabSize: 2
        smartIndent: false
        readOnly: true

    $mustacheCodeMirror = $("#mustache .CodeMirror")
    $jsonCodeMirror = $("#json .CodeMirror")
    $outputCodeMirror = $("#output .CodeMirror")
    
    onChange = (doc, changeObj) ->
        $cmMustache.removeClass "is-invalid"
        $cmJson.removeClass "is-invalid"
        
        try
            json = JSON.parse cmJson.getValue()
        catch e
            $cmJson.addClass "is-invalid"
            cmOutput.setValue "Invalid JSON:\n#{e.message}\n\nVerify your JSON Feed through:\nhttp://www.jslint.com/" 
            return false

        mustache = cmMustache.getValue()

        try
            output = Mustache.render mustache, json
            cmOutput.setValue(output)
            console.log output
        catch e
            $cmMustache.addClass "is-invalid"
            cmOutput.setValue "Mustache error:\n#{e.message}"

    updateUI = ->
        offsetWindowHeight = $(".footer-container").outerHeight(true) + 50;
        unless $(window).width() > 954
            $mustacheCodeMirror.css("height", "")
            $jsonCodeMirror.css("height", "")
            $outputCodeMirror.css("height", "")
            return 
        console.log "now"
        windowsHeight = $(window).height()
        offset = $("#mustache").offset()
        $mustacheCodeMirror.height (windowsHeight - offset.top - offsetWindowHeight)
        $jsonCodeMirror.height (windowsHeight - offset.top - offsetWindowHeight)
        $outputCodeMirror.height (windowsHeight - offset.top - offsetWindowHeight)

        console.log $mustacheCodeMirror
    

    cmMustache.on "change", onChange
    cmJson.on "change", onChange
    $(window).resize updateUI

    onChange()
    updateUI()


window.templateMustache = "{{#contacts}}\n
<div>\n
  <div>first-name: {{first-name}}</div>\n
  <div>last-name: {{last-name}}</div>\n
  <div>phone: {{phone}}</div>\n
</div>\n
{{/contacts}}\n"


window.templateJson = "{\n
    \"contacts\": [ \n
      { \"first-name\" : \"Aenean\",\n
        \"last-name\" : \"Nullam\",\n
        \"phone\" : \"(965)420-5608\"\n
      },\n
      { \"first-name\" : \"Aenean\",\n
        \"last-name\" : \"Erat\",\n
        \"phone\" : \"(699)917-1169\"\n
      },\n
      { \"first-name\" : \"Aenean\",\n
        \"last-name\" : \"Volutpat\",\n
        \"phone\" : \"(443)531-9176\"\n
      }\n
    ]\n
}"

### 
window.templateMustache = "{{#contacts}}\n
<div class=\"contact\" data-attr=\"{{uid}}\">\n
  <div>first-name: {{first-name}}</div>\n
  <div>last-name: {{last-name}}</div>\n
  <div>phone: {{area-code}}-{{phone}}</div>\n
  <div>birthday: {{birthday}}</div>\n
  <div>address: {{address-number}} {{street}}, {{city}}, {{state}}</div>\n
  <div>e-mail: {{email}}</div>\n
</div>\n
{{/contacts}}\n"


window.templateJson = "{\n
    \"contacts\": {\n
        \"uid\": \"GUID\",\n
        \"first-name\": \"lorem:1...2\",\n
        \"last-name\": \"lorem:1...2\",\n
        \"phone\": \"(|200...980|)|100...999|-|1000-9999\",\n
        \"birthday\": \"1...12|/|1...31|/|1960...2013\",\n
        \"address-number\": \"1...2000|-|ABC:1\",\n
        \"street\": \"lorem:1...3\",\n
        \"city\": [\"New York City\", \"Albany\", \"Buffalo\", \"Rochester\", \"Syracuse\", \"Yonkers\", \"Ithaca\", \"Binghamton\", \"Schenectady\", \"White Plains\", \"Poughkeepsie\"],\n
        \"state\": [\"AL\", \"AK\", \"NY\", \"DE\", \"FL\"],\n
        \"email\":  \"lorem:1...1|@|lorem:1...1|.com\"\n
    }\n
}"
###

