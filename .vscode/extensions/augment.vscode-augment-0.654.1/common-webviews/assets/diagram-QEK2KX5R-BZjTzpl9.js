import{_ as l,s as O,g as S,t as D,q as E,a as F,b as z,K as _,z as P,F as v,G as C,H as R,l as G,a1 as B}from"./AugmentMessage-C4nlI3wE.js";import{p as V}from"./chunk-4BX2VUAB-B-xR4kT9.js";import{p as W}from"./treemap-KMMF4GRG-ptlCvvLC.js";import"./Icon-sLaU9wft.js";import"./index-DHSjOx9e.js";import"./preload-helper-iZIsTGZK.js";import"./await-CHVHWvUu.js";import"./index-B4NDmpYR.js";import"./IconButtonAugment-daSugom5.js";/* empty css                                                */import"./Store-KXRq7SKm.js";import"./CardAugment-BKsBZ31X.js";import"./focusTrapStack-CB56QuZc.js";import"./Chevron-D7W0FKA6.js";import"./BaseTextInput-D2DDS3hK.js";import"./message-broker-B_uRZ3qw.js";import"./index-CxaqtcR-.js";import"./index-Bz1AJAWu.js";import"./chat-model-DYZ8xmp_.js";import"./file-type-utils-PpV57xHw.js";import"./CalloutAugment-BXtxDWUU.js";import"./types-DGsjtdxm.js";import"./chat-model-context-wI5bjvFT.js";import"./Markdown-YEeRT8_s.js";import"./toggleHighContrast-DPV9-mxX.js";import"./ButtonAugment-CUctDXs-.js";import"./Filespan-B4x6agGW.js";import"./OpenFileButton-CXbzvFTn.js";import"./index-nbgGMYE9.js";import"./remote-agents-client-CT2uJ4tm.js";import"./SuccessfulButton-7rdATM2K.js";import"./CopyButton-jZ1U8mjO.js";import"./LanguageIcon-mGS1XYrl.js";import"./CollapseButtonAugment-v0dTiRMN.js";import"./keypress-fD7XHdyk.js";import"./TextAreaAugment-9HMVBCFm.js";import"./partner-mcp-utils-DCKCA3f-.js";import"./utils-BVEnE4cn.js";import"./_baseUniq-B--wz271.js";import"./_basePickBy-Cnnkl9bC.js";import"./clone-BsWfYDGk.js";try{h=typeof window<"u"?window:typeof global<"u"?global:typeof globalThis<"u"?globalThis:typeof self<"u"?self:{},(w=new h.Error().stack)&&(h._sentryDebugIds=h._sentryDebugIds||{},h._sentryDebugIds[w]="e0116f83-35fd-4501-a279-db90fe301ba5",h._sentryDebugIdIdentifier="sentry-dbid-e0116f83-35fd-4501-a279-db90fe301ba5")}catch{}var h,w,x={showLegend:!0,ticks:5,max:null,min:0,graticule:"circle"},M={axes:[],curves:[],options:x},g=structuredClone(M),j=R.radar,H=l(()=>v({...j,...C().radar}),"getConfig"),L=l(()=>g.axes,"getAxes"),q=l(()=>g.curves,"getCurves"),K=l(()=>g.options,"getOptions"),Z=l(a=>{g.axes=a.map(t=>({name:t.name,label:t.label??t.name}))},"setAxes"),J=l(a=>{g.curves=a.map(t=>({name:t.name,label:t.label??t.name,entries:N(t.entries)}))},"setCurves"),N=l(a=>{if(a[0].axis==null)return a.map(e=>e.value);const t=L();if(t.length===0)throw new Error("Axes must be populated before curves for reference entries");return t.map(e=>{const r=a.find(n=>n.axis?.$refText===e.name);if(r===void 0)throw new Error("Missing entry for axis "+e.label);return r.value})},"computeCurveEntries"),$={getAxes:L,getCurves:q,getOptions:K,setAxes:Z,setCurves:J,setOptions:l(a=>{const t=a.reduce((e,r)=>(e[r.name]=r,e),{});g.options={showLegend:t.showLegend?.value??x.showLegend,ticks:t.ticks?.value??x.ticks,max:t.max?.value??x.max,min:t.min?.value??x.min,graticule:t.graticule?.value??x.graticule}},"setOptions"),getConfig:H,clear:l(()=>{P(),g=structuredClone(M)},"clear"),setAccTitle:z,getAccTitle:F,setDiagramTitle:E,getDiagramTitle:D,getAccDescription:S,setAccDescription:O},Q=l(a=>{V(a,$);const{axes:t,curves:e,options:r}=a;$.setAxes(t),$.setCurves(e),$.setOptions(r)},"populate"),U={parse:l(async a=>{const t=await W("radar",a);G.debug(t),Q(t)},"parse")},X=l((a,t,e,r)=>{const n=r.db,o=n.getAxes(),s=n.getCurves(),i=n.getOptions(),c=n.getConfig(),m=n.getDiagramTitle(),d=_(t),p=Y(d,c),u=i.max??Math.max(...s.map(y=>Math.max(...y.entries))),b=i.min,f=Math.min(c.width,c.height)/2;tt(p,o,f,i.ticks,i.graticule),et(p,o,f,c),T(p,o,s,b,u,i.graticule,c),I(p,s,i.showLegend,c),p.append("text").attr("class","radarTitle").text(m).attr("x",0).attr("y",-c.height/2-c.marginTop)},"draw"),Y=l((a,t)=>{const e=t.width+t.marginLeft+t.marginRight,r=t.height+t.marginTop+t.marginBottom,n=t.marginLeft+t.width/2,o=t.marginTop+t.height/2;return a.attr("viewbox",`0 0 ${e} ${r}`).attr("width",e).attr("height",r),a.append("g").attr("transform",`translate(${n}, ${o})`)},"drawFrame"),tt=l((a,t,e,r,n)=>{if(n==="circle")for(let o=0;o<r;o++){const s=e*(o+1)/r;a.append("circle").attr("r",s).attr("class","radarGraticule")}else if(n==="polygon"){const o=t.length;for(let s=0;s<r;s++){const i=e*(s+1)/r,c=t.map((m,d)=>{const p=2*d*Math.PI/o-Math.PI/2;return`${i*Math.cos(p)},${i*Math.sin(p)}`}).join(" ");a.append("polygon").attr("points",c).attr("class","radarGraticule")}}},"drawGraticule"),et=l((a,t,e,r)=>{const n=t.length;for(let o=0;o<n;o++){const s=t[o].label,i=2*o*Math.PI/n-Math.PI/2;a.append("line").attr("x1",0).attr("y1",0).attr("x2",e*r.axisScaleFactor*Math.cos(i)).attr("y2",e*r.axisScaleFactor*Math.sin(i)).attr("class","radarAxisLine"),a.append("text").text(s).attr("x",e*r.axisLabelFactor*Math.cos(i)).attr("y",e*r.axisLabelFactor*Math.sin(i)).attr("class","radarAxisLabel")}},"drawAxes");function T(a,t,e,r,n,o,s){const i=t.length,c=Math.min(s.width,s.height)/2;e.forEach((m,d)=>{if(m.entries.length!==i)return;const p=m.entries.map((u,b)=>{const f=2*Math.PI*b/i-Math.PI/2,y=k(u,r,n,c);return{x:y*Math.cos(f),y:y*Math.sin(f)}});o==="circle"?a.append("path").attr("d",A(p,s.curveTension)).attr("class",`radarCurve-${d}`):o==="polygon"&&a.append("polygon").attr("points",p.map(u=>`${u.x},${u.y}`).join(" ")).attr("class",`radarCurve-${d}`)})}function k(a,t,e,r){return r*(Math.min(Math.max(a,t),e)-t)/(e-t)}function A(a,t){const e=a.length;let r=`M${a[0].x},${a[0].y}`;for(let n=0;n<e;n++){const o=a[(n-1+e)%e],s=a[n],i=a[(n+1)%e],c=a[(n+2)%e],m={x:s.x+(i.x-o.x)*t,y:s.y+(i.y-o.y)*t},d={x:i.x-(c.x-s.x)*t,y:i.y-(c.y-s.y)*t};r+=` C${m.x},${m.y} ${d.x},${d.y} ${i.x},${i.y}`}return`${r} Z`}function I(a,t,e,r){if(!e)return;const n=3*(r.width/2+r.marginRight)/4,o=3*-(r.height/2+r.marginTop)/4;t.forEach((s,i)=>{const c=a.append("g").attr("transform",`translate(${n}, ${o+20*i})`);c.append("rect").attr("width",12).attr("height",12).attr("class",`radarLegendBox-${i}`),c.append("text").attr("x",16).attr("y",0).attr("class","radarLegendText").text(s.label)})}l(T,"drawCurves"),l(k,"relativeRadius"),l(A,"closedRoundCurve"),l(I,"drawLegend");var at={draw:X},rt=l((a,t)=>{let e="";for(let r=0;r<a.THEME_COLOR_LIMIT;r++){const n=a[`cScale${r}`];e+=`
		.radarCurve-${r} {
			color: ${n};
			fill: ${n};
			fill-opacity: ${t.curveOpacity};
			stroke: ${n};
			stroke-width: ${t.curveStrokeWidth};
		}
		.radarLegendBox-${r} {
			fill: ${n};
			fill-opacity: ${t.curveOpacity};
			stroke: ${n};
		}
		`}return e},"genIndexStyles"),nt=l(a=>{const t=B(),e=C(),r=v(t,e.themeVariables);return{themeVariables:r,radarOptions:v(r.radar,a)}},"buildRadarStyleOptions"),Kt={parser:U,db:$,renderer:at,styles:l(({radar:a}={})=>{const{themeVariables:t,radarOptions:e}=nt(a);return`
	.radarTitle {
		font-size: ${t.fontSize};
		color: ${t.titleColor};
		dominant-baseline: hanging;
		text-anchor: middle;
	}
	.radarAxisLine {
		stroke: ${e.axisColor};
		stroke-width: ${e.axisStrokeWidth};
	}
	.radarAxisLabel {
		dominant-baseline: middle;
		text-anchor: middle;
		font-size: ${e.axisLabelFontSize}px;
		color: ${e.axisColor};
	}
	.radarGraticule {
		fill: ${e.graticuleColor};
		fill-opacity: ${e.graticuleOpacity};
		stroke: ${e.graticuleColor};
		stroke-width: ${e.graticuleStrokeWidth};
	}
	.radarLegendText {
		text-anchor: start;
		font-size: ${e.legendFontSize}px;
		dominant-baseline: hanging;
	}
	${rt(t,e)}
	`},"styles")};export{Kt as diagram};
//# sourceMappingURL=diagram-QEK2KX5R-BZjTzpl9.js.map
