import React from 'react';
import {Book} from "../models/Book";
import {Position} from "../models/Position";
import {Trader} from "../models/Trader";
import {Checks} from "../models/Checks";

export class Output extends React.Component {

    avgLen = 20;

    outputBuffer: Array<string> = [];
    buffer: Array<number> = [];

    deltasWeighted: { delta1: Array<number>, delta2: Array<number> } = {
        delta1: [],
        delta2: [],
    };

    state = {
        openingBalance: 1000,
        balance: 1000,
        trades: 0,
        feePerc: 0.05,
        c1: 1,
        c2: 2
    };

    trader: Trader = new Trader();

    book: Book = new Book(1000, 0, [], 0.5);

    constructor(props: any) {
        super(props);
        this.getRandom = this.getRandom.bind(this);
        this.calculate = this.calculate.bind(this);
    }

    componentDidMount(): void {
        this.calculate();
    }

    getAverage(deltaList: Array<number>) {
        let dx = 0;
        deltaList.forEach((d: number) => {
            dx += d;
        });
        return dx / deltaList.length;
    }

    getRandomN() {
        return Math.random() * Math.random() * 500;
    }

    addDelta(delta: Array<number>) {
        delta.push(this.getRandomN());
        if (delta.length > this.avgLen) {
            delta.splice(0, 1);
        }
        return this.getAverage(delta);
    }

    getRandom() {
        return {
            avg1: this.addDelta(this.deltasWeighted.delta1),
            avg2: this.addDelta(this.deltasWeighted.delta2)
        }
    }

    prime() {
        let n = 0;
        while (n++ < this.avgLen) {
            this.getRandom();
        }
    }

    rnd(amount: number) {
        return `${Math.round(1000 * amount) / 1000}          `;
    }

    getRatio(c1: number, c2: number) {
        const ratio = c1 / c2;
        return Math.abs(5 * Math.round(1000 * ratio) / 1000);
    }

    doTrade() {
        this.buffer.forEach((price) => {
            const trade = this.trader.makeTrade(this.book, price);
            if (trade) {
                this.book.positions.push(trade);
            }
        });
    }

    calculate() {
        this.prime();
        let n = 0;
        let deltas = {avg1: 0, avg2: 0};
        let c1 = 0, c2 = 0;
        while (n++ < 200) {
            deltas = this.getRandom();
            c1 = deltas.avg1;
            c2 = deltas.avg2;
            const ratio = this.getRatio(c1, c2);
            this.outputBuffer.push(`${ratio}`);
            this.buffer.push(ratio);
            console.log({c1, c2, ratio});
        }
        this.setState({c1, c2});
        this.doTrade();
    }

    printOutput() {
        console.log(`book.positions`, this.book.positions);
        let output = '';
        let finalPrice = this.buffer[this.buffer.length - 1];
        let profit = 0;
        let minProfit = 0;
        let maxProfit = 0;
        this.book.positions.forEach((pos: Position) => {
            profit += this.trader.getProfit(pos, finalPrice);
            // minProfit = (profit < minProfit) ? profit : minProfit;
            // maxProfit = (profit > maxProfit) ? profit : minProfit;
            output += `amount: ${this.rnd(pos.amount)} \t price: ${this.rnd(pos.price)}...${this.rnd(finalPrice)} \t profit: ${this.rnd(profit)} \t risk: ${this.rnd(pos.risk)}\n`;
        });
        output += `\n closing price: ${finalPrice}`;
        return output;
    }

    check() {
        let finalPrice = this.buffer[this.buffer.length - 1];
        console.log(`this.book : ${finalPrice}`, this.book);
        return Checks.checkProfit() ? 'yes' : 'no';
    }

    render() {
        return <pre>{this.printOutput()}</pre>
        // return <pre>{this.check()}</pre>
    }
}
