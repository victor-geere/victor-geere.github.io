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
        const plot = [];
        const mid = (points[0].x + points[1].x) / 2;
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
        const curve = makeSimpleCurve(plot, getMaterial(colorsGrey, 1));
        this.guides.push(curve);
    },
    addGuides: function() {
        this.guides = [];
        this.addGuide(160000);
        this.addGuide(80000);
        this.addGuide(40000);
        this.addGuide(20000);
        this.addGuide(10000);
        this.addGuide(0);
        return this.guides;
    },
    updateGuides: function () {
        const y = [0, 10000, 20000, 40000, 80000, 160000];
        const guidelines = [
            [{ x: -2000, y: y[5] }, { x: 2000, y: y[5] }],
            [{ x: -2000, y: y[4] }, { x: 2000, y: y[4] }],
            [{ x: -2000, y: y[3] }, { x: 2000, y: y[3] }],
            [{ x: -2000, y: y[2] }, { x: 2000, y: y[2] }],
            [{ x: -2000, y: y[1] }, { x: 2000, y: y[1] }],
            [{ x: -2000, y: y[0] }, { x: 2000, y: y[0] }]
        ];
        this.guides.forEach((guide, ix) => {
            guide.updatePoints(this.makeGuidePoints(guidelines[ix]));
        })
    }
};

export { graph }
