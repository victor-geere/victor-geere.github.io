import {getBaseScene, setEmission, getPlayerTypeName} from "./basescene.js";

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
            piece.on('mouseover', universe.game.intersectObjects.bind(universe.game, universe, piece));
            piece.on('mouseout', universe.game.cleanIntersected.bind(universe.game, universe, piece));
        },
        intersectObjects: (universe, piece) => {
            universe.game.onPieceOver(universe, piece);
        },
        cleanIntersected: (universe, piece) => {
            universe.game.onPieceOut(universe, piece);
        },
    };
    return {
        ...baseScene,
        vrSupported: false,
    }
}

export { getWebScene }
