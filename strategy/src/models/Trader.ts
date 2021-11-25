import {Book} from "./Book";
import {Position} from "./Position";

export class Trader {

    options: any = {
        minTrade: 10
    };

    getProfit(position: Position, price: number) {
        const movement = ((price - position.price) / position.price);
        return movement * position.amount;
    }

    evaluate(positions: Array<Position>, price: number) {
        let unrealised: number = 0;
        let invested: number = 0;
        positions.forEach((position: Position) => {
            invested += position.amount;
            unrealised += this.getProfit(position, price);
        });
        return {unrealised, invested};
    }

    takeProfit(book: Book, takeAmount: number) {
        
    }

    makeTrade(book: Book, state: { c1: number, c2: number, c1Balance: number, c2Balance: number, ratio: number} | any): {aState: any, position?: Position | null} {
        const aState = { ...state };
        let position: Position | null;
        const c1Value = aState.c1 * aState.c1Balance;
        const c2Value = aState.c2 * aState.c2Balance;
        const diffValue = (c1Value - c2Value) / 2;
        if (Math.abs(diffValue) > 100) {
            const c1DiffVolume =  diffValue / aState.c1;
            const c2DiffVolume =  diffValue / aState.c2;
            aState.c1Balance += c1DiffVolume;
            aState.c2Balance += c2DiffVolume;
            position = new Position(0, 0, 0, 0, 0, 0);
        } else {
            position = null
        }
        return {aState, position};
    }
}
