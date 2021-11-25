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

    makeTrade(book: Book, state: { c1: number, c2: number, c1Balance: number, c2Balance: number, ratio: number}): Position | null {
        let position = null;
        const c1Value = state.c1 * state.c1Balance;
        const c2Value = state.c2 * state.c2Balance;



/*
        const valuation = this.evaluate(book.positions, price);
        const balance = valuation.unrealised + valuation.invested;
        const worth = valuation.unrealised + valuation.invested + book.balance;
        const risk = balance / worth;
        if (risk < book.targetRisk) {
            const diffRisk = book.targetRisk - risk;
            const diffAmount = worth * diffRisk;
            if (diffAmount > this.options.minTrade) {
                position = new Position(price, diffAmount, valuation.unrealised, valuation.invested, book.balance, risk);
                book.useBalance(diffAmount);
            }
        } else if (risk > book.targetRisk) {
            const diffRisk = risk - book.targetRisk;
            const diffAmount = worth * diffRisk;
            if (diffAmount > this.options.minTrade) {
                this.takeProfit(book, diffAmount);
                // position = new Position(price, -diffAmount, valuation.unrealised, valuation.invested, book.balance, risk);
                // book.addBalance(diffAmount);
            }
        }

 */
        return position;
    }
}
