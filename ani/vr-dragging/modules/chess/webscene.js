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
            console.log(`piece.userData`, piece.userData);
            const playerName = getPlayerTypeName(piece.userData.player.type);
            setEmission(piece.material.emissive, universe.settings.pieces.emissive.intersected[playerName]);
        },
        cleanIntersected: (universe, piece) => {
            console.log(`piece.userData`, piece.userData);
            if (piece.userData.state.selected) {
                const playerName = getPlayerTypeName(piece.userData.player.type);
                setEmission(piece.material.emissive, universe.settings.pieces.emissive.selected[playerName]);
            } else {
                setEmission(piece.material.emissive, universe.settings.pieces.emissive.default);
            }
        },
    };
    return {
        ...baseScene,
        vrSupported: false,
    }
}

export { getWebScene }
