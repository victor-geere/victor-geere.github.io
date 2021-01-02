import { GUI } from '../../../lib/dat.gui.module.js'

function popGui(gui) {
    gui.controllers = {};
    gui.parameters = {};
    gui.params = {};
    gui.init.forEach((item) => {
        gui.parameters[item.param] = item.default;
    });
    gui.options.load = gui.parameters;
    const datGui = new GUI(gui.options);
    gui.init.forEach((item) => {
        gui.controllers[item.ctrl] = datGui.add(gui.parameters, item.param, item.min, item.max, item.interval)
            .onChange(item.onChange).onFinishChange(item.onFinishChange);
    });
}

export { popGui }
