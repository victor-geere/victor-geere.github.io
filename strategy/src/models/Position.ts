export class Position {
    price: number = 0;
    amount: number = 0;
    unrealised: number = 0;
    invested: number = 0;
    balance: number = 0;
    risk: number;

    constructor(openPrice: number, amount: number, unrealised: number, invested: number, balance: number, risk: number) {
        this.price = openPrice;
        this.amount = amount;
        this.unrealised = unrealised;
        this.invested = invested;
        this.balance = balance;
        this.risk = risk;
    }

}
