module.exports =

    handle: ->
        path = @editor.getPath()
        row = @editor.getLastBufferRow()
        variable = @editor.getSelectedText()

        atom.notifications.addSuccess 'Local variable was converted to instance variable.'
        atom.notifications.addError 'Local variable was converted to instance variable.'

        console.log 'Converted'
