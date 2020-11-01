import {getBaseScene} from "./basescene.js";

function getWebScene() {
    const baseScene = getBaseScene();
    baseScene.game = {
        ...baseScene.game,
        onSelectStart: () => {
        },
        onSelectEnd: () => {
        },
        setPiece(piece) {

        },
        addPieceEvents: (piece, universe) => {
            piece.cursor = 'pointer';
            piece.on('click', universe.game.onClickPiece.bind(universe.game, universe, piece));
        },
    };
    return {
        ...baseScene,
        vrSupported: false,
    }
}

export { getWebScene }
