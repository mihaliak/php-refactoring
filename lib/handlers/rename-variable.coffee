{runCommand} = require '../php-refactoring'

module.exports =
    editor: atom.workspace.getActiveTextEditor()

    handle: (name) ->
        path = @editor.getPath()
        row = @editor.getLastBufferRow()
        variable = @editor.getSelectedText()

        runCommand ['rename-local-variable', path, row, variable, name]
