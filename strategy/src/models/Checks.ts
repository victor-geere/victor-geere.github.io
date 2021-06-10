import {Trader} from "./Trader";
import {Position} from "./Position";

export class Checks {
    static checkProfit() {
        const trader = new Trader();
        const position = new Position(1, 100, 0,0,0, 0);
        const profit = trader.getProfit(position, 1.5);
        console.log(`profit`, profit);
        return profit === 50;
    }
}
