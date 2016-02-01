module.exports =
    editor: atom.workspace.getActiveTextEditor()

    getLineRange: ->
        return {
            start: @editor.getSelectedBufferRanges()[0].start.row + 1,
            end: @editor.getSelectedBufferRanges()[0].end.row + 1
        }

    handle: (name) ->
        path = @editor.getPath()
        lines = @getLineRange()

        runCommand ['extract-method', path, lines.start + '-' + lines.end, name]
