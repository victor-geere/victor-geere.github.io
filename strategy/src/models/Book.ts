import {Position} from "./Position";

export class Book {
    balance: number = 0;
    trades: number = 0;
    positions: Array<Position> = [];
    targetRisk: number = 0;

    constructor(balance: number, trades: number, positions: Array<Position>, targetRisk: number) {
        this.balance = balance;
        this.trades = trades;
        this.positions = positions;
        this.targetRisk = targetRisk;
    }

    useBalance(amount: number) {
        this.balance = this.balance - amount;
    }

    addBalance(amount: number) {
        this.balance = this.balance + amount;
    }
}
