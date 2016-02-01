module.exports =
    editor: atom.workspace.getActiveTextEditor()
    
    handle: ->
        path = @editor.getPath()

        console.log 'Optimized'
