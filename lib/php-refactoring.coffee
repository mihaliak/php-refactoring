{CompositeDisposable, BufferedProcess} = require 'atom'
{$, TextEditorView, View}  = require 'atom-space-pen-views'
{exec} = require 'child_process'
RefactorView = require './refactor-view'
Path = require 'path'

module.exports = PhpRefactoring =
    subscriptions: null
    config:
        phpExecutablePath:
            title: 'PHP executable path'
            type: 'string'
            default: 'php'
            description: 'The path to the `php` executable'
        executablePath:
            title: 'Refactor executable path'
            type: 'string'
            default: '~/refactor.phar'
            description: 'The path to the `refactor.phar`'
        patchPath:
            title: 'Path to patch command'
            type: 'string'
            default: 'patch'
            description: 'The path to the `patch` command. For windows read installation instructions'
        showInfoNotifications:
            title: 'Show notifications'
            type: 'boolean'
            default: true
            description: 'Show refactoring notifications'
    refactorPanel: new RefactorView
    handler: null
    editor: atom.workspace.getActiveTextEditor()

    activate: (state) ->
        atom.config.observe 'php-refactoring.phpExecutablePath', =>
            @phpExecutablePath = atom.config.get 'php-refactoring.phpExecutablePath'

        atom.config.observe 'php-refactoring.executablePath', =>
            @executablePath = atom.config.get 'php-refactoring.executablePath'

        atom.config.observe 'php-refactoring.patchPath', =>
            @patchPath = atom.config.get 'php-refactoring.patchPath'

        atom.config.observe 'php-refactoring.showInfoNotifications', =>
            @showInfoNotifications = atom.config.get 'php-refactoring.showInfoNotifications'

        @subscriptions = new CompositeDisposable

        @subscriptions.add atom.commands.add 'atom-text-editor',
            'php-refactoring:extract': => @setHandlerAndTogglePanel(1)
            'php-refactoring:rename-variable': => @setHandlerAndTogglePanel(2)
            'php-refactoring:convert-variable': => @convertVariable()
            'php-refactoring:optimize': => @optimize()

        @subscriptions.add atom.commands.add @refactorPanel.inputObject.element, 'core:confirm', => @handleConfirm()

    deactivate: ->
        @subscriptions.dispose()

    handleConfirm: ->
        @handler()
        @refactorPanel.hideModal()

    setHandlerAndTogglePanel: (type) ->
        if type == 1
            @handler = @extractMethod
        else
            @handler = @renameVariable

        @refactorPanel.showModal()

    extractMethod: ->
        path = @editor.getPath()
        methodStart = @editor.getSelectedBufferRange().start.row + 1
        methodEnd = @editor.getSelectedBufferRange().end.row + 1
        name = @refactorPanel.inputObject.getText()

        @runCommand ['extract-method', path, methodStart + '-' + methodEnd, name]

    renameVariable: ->
        path = @editor.getPath()
        row = @editor.getSelectedBufferRange().start.row + 1
        variable = @editor.getSelectedText().replace /\$/g, ''
        name = @refactorPanel.inputObject.getText()

        @runCommand ['rename-local-variable', path, row, variable, name]

    convertVariable: ->
        path = @editor.getPath()
        row = @editor.getSelectedBufferRange().start.row + 1
        variable = @editor.getSelectedText().replace /\$/g, ''

        @runCommand ['convert-local-to-instance-variable', path, row, variable]

    optimize: ->
        path = @editor.getPath()

        @runCommand ['optimize-use', path]

    runCommand: (args) ->
        @editor.save()

        command = ['cd "' + Path.dirname(args[1]) + '" && ']

        args[1] = '"' + args[1] + '"'

        command.push '"' + PhpRefactoring.phpExecutablePath + '"'
        command.push '"' + PhpRefactoring.executablePath + '"'
        command.push args...
        command.push '| "' + PhpRefactoring.patchPath + '" -p1 -t'
        command = command.toString().replace /,/g, ' '

        stdout = (output) ->
            if PhpRefactoring.showInfoNotifications
                atom.notifications.addSuccess('Code was refactored!')

        stderr = (output) ->
            atom.notifications.addError(output)

        exit = (code) -> console.log("#{command} Exited with code: #{code}")

        commandProccess = exec(command);

        commandProccess.stdout.on 'data', stdout
        commandProccess.stderr.on 'data', stderr
        commandProccess.on 'close', exit
