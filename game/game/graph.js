import { getMaterial } from "../modules/materials.js";
import { colorsGrey, rainbow } from '../modules/colors.js';
import {
    makeSimpleCurve,
    newVec
} from '../modules/threetools.js';

const graph = {
    scale: {
        min: null,
        max: null,
        vMid: null
    },
    guides: [],
    max: 0,
    newMax: function(value) {
        if (value > this.max * 1.1) {
            this.max = value;
        }
    },
    getScale: function(points) {
        this.scale.min = null;
        this.scale.max = null;
        this.scale.vMid = null;

        points.forEach((point) => {
            if (this.scale.max === null || point.y > this.scale.max) {
                this.newMax(point.y);
                this.scale.max = point.y;
            }
            if (this.scale.min === null || point.y < this.scale.min) {
                this.scale.min = point.y;
            }
        });
        this.scale.vMid = (this.scale.max + this.scale.min) / 2;
    },
    makePoints: function(points) {
        const xFactor = 10;
        const mid = points.length / ( 2 * xFactor );
        const plot = [];
        let x = 0;
        this.getScale(points);
        points.forEach((point) => {
            plot.push(newVec(x++/xFactor - mid, (point.y - this.scale.vMid) / 2000, 0));
        });
        return plot;
    },
    makeGuidePoints: function(points) {
        const mid = (points[0].x + points[1].x) / 2;
        const plot = [];
        points.forEach((point) => {
            plot.push(newVec(point.x - mid, (point.y - this.scale.vMid) / 2000, 0));
        });
        return plot;
    },
    addPlotAsGraphToScene: function(points, colorN, palette = colorsGrey) {
        const plot = this.makePoints(points);
        return makeSimpleCurve(plot, getMaterial(palette, colorN));
        // sceneInfo.addObject(curve);
        // return curve;
    },
    addGuide: function(n) {
        const points = [{ x: -2000, y: n }, { x: 2000, y: n }];
        const plot = this.makeGuidePoints(points);
        const curve = makeSimpleCurve(plot, getMaterial(colorsGrey, 2));
        this.guides.push(curve);
    },
    addGuides: function() {
        this.addGuide(200000);
        this.addGuide(175000);
        this.addGuide(150000);
        this.addGuide(100000);
        this.addGuide(50000);
        this.addGuide(25000);
        this.addGuide(0);
        return this.guides;
    },
    updateGuides: function () {
        const guidelines = [
            [{ x: -2000, y: 200000 }, { x: 2000, y: 200000 }],
            [{ x: -2000, y: 175000 }, { x: 2000, y: 175000 }],
            [{ x: -2000, y: 150000 }, { x: 2000, y: 150000 }],
            [{ x: -2000, y: 100000 }, { x: 2000, y: 100000 }],
            [{ x: -2000, y: 50000 }, { x: 2000, y: 50000 }],
            [{ x: -2000, y: 25000 }, { x: 2000, y: 25000 }],
            [{ x: -2000, y: 0 }, { x: 2000, y: 0 }]
        ];
        this.guides.forEach((guide, ix) => {
            guide.updatePoints(this.makeGuidePoints(guidelines[ix]));
        })
    }
};

export { graph }
