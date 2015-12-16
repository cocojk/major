* TINY Compilation to TM Code
* File: hardOp.tm
* Standard prelude:
* End of standard prelude.
  0:    ADD  3,4,5 	move sp -> fp
  1:    LDC  5,1(0) 	temp use zp for push
  2:    ADD  4,4,5 	push stack address
  3:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
  4:    LDC  0,10(0) 	load const
* <- Const
  5:     ST  0,0(4) 	insert parameter 
  6:    LDC  5,1(0) 	temp use zp for push
  7:    ADD  4,4,5 	push stack address
  8:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
  9:    LDC  0,3(0) 	load const
* <- Const
 10:     ST  0,0(4) 	insert parameter 
 11:    LDC  5,1(0) 	temp use zp for push
 12:    ADD  4,4,5 	push stack address
 13:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 14:    LDC  0,2(0) 	load const
* <- Const
 15:     ST  0,0(4) 	insert parameter 
 16:    LDC  5,1(0) 	temp use zp for push
 17:    ADD  4,4,5 	push stack address
 18:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 19:    LDC  0,5(0) 	load const
* <- Const
 20:     ST  0,0(4) 	insert parameter 
 21:    LDC  5,1(0) 	temp use zp for push
 22:    ADD  4,4,5 	push stack address
 23:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 24:    LDC  0,2(0) 	load const
* <- Const
 25:     ST  0,0(4) 	insert parameter 
 26:    LDC  5,1(0) 	temp use zp for push
 27:    ADD  4,4,5 	push stack address
 28:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 29:    LDC  0,4(0) 	load const
* <- Const
 30:     ST  0,0(4) 	insert parameter 
 31:    LDC  5,1(0) 	temp use zp for push
 32:    ADD  4,4,5 	push stack address
 33:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 34:    LDC  0,5(0) 	load const
* <- Const
 35:     ST  0,0(4) 	insert parameter 
 36:    LDC  5,1(0) 	temp use zp for push
 37:    ADD  4,4,5 	push stack address
 38:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 39:    LDC  0,2(0) 	load const
* <- Const
 40:     ST  0,0(4) 	insert parameter 
 41:    LDC  5,1(0) 	temp use zp for push
 42:    ADD  4,4,5 	push stack address
 43:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
 44:    LDC  0,3(0) 	load const
* <- Const
 45:     ST  0,0(4) 	insert parameter 
 46:    LDC  5,1(0) 	temp use zp for push
 47:    ADD  4,4,5 	push stack address
 48:    LDC  5,0(0) 	return zp 0
 49:     ST  3,0(4) 	save old fp
 50:    LDC  5,1(0) 	temp use zp for push
 51:    ADD  4,4,5 	push stack address
 52:    LDC  5,0(0) 	return zp 0
 53:    ADD  3,4,5 	sp->fp
 54:    LDC  0,10(0) 	parameternum -> ac
 55:     ST  0,0(4) 	save old sp
 56:    LDC  5,1(0) 	temp use zp for push
 57:    ADD  4,4,5 	push stack address
 58:    LDC  5,0(0) 	return zp 0
 59:    LDC  0,0(0) 	local variable store at ac
 60:     ST  0,1(3) 	local variable store at localoff(fp)
 61:    LDC  5,1(0) 	temp use zp for push
 62:    ADD  4,4,5 	push stack address
 63:    LDC  5,0(0) 	return zp 0
 64:    LDC  0,0(0) 	local variable store at ac
 65:     ST  0,2(3) 	local variable store at localoff(fp)
 66:    LDC  5,1(0) 	temp use zp for push
 67:    ADD  4,4,5 	push stack address
 68:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Op
* -> Op
* -> Op
* -> Id
 69:     LD  0,-10(3) 	load local id value
* <- Id
 70:     ST  0,0(4) 	op: push left
 71:    LDC  5,1(0) 	temp use zp for push
 72:    ADD  4,4,5 	push stack address
 73:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
 74:     LD  0,-9(3) 	load local id value
* <- Id
 75:     ST  0,0(4) 	op: push left
 76:    LDC  5,1(0) 	temp use zp for push
 77:    ADD  4,4,5 	push stack address
 78:    LDC  5,0(0) 	return zp 0
* -> Id
 79:     LD  0,-8(3) 	load local id value
* <- Id
 80:    LDC  5,1(0) 	temp use zp for pop
 81:    SUB  4,4,5 	pop stack address
 82:    LDC  5,0(0) 	return zp 0
 83:     LD  1,0(4) 	op: load left
 84:    SUB  0,1,0 	op -
* <- Op
 85:    LDC  5,1(0) 	temp use zp for pop
 86:    SUB  4,4,5 	pop stack address
 87:    LDC  5,0(0) 	return zp 0
 88:     LD  1,0(4) 	op: load left
 89:    ADD  0,1,0 	op +
* <- Op
 90:     ST  0,0(4) 	op: push left
 91:    LDC  5,1(0) 	temp use zp for push
 92:    ADD  4,4,5 	push stack address
 93:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Op
* -> Op
* -> Id
 94:     LD  0,-6(3) 	load local id value
* <- Id
 95:     ST  0,0(4) 	op: push left
 96:    LDC  5,1(0) 	temp use zp for push
 97:    ADD  4,4,5 	push stack address
 98:    LDC  5,0(0) 	return zp 0
* -> Id
 99:     LD  0,-5(3) 	load local id value
* <- Id
100:    LDC  5,1(0) 	temp use zp for pop
101:    SUB  4,4,5 	pop stack address
102:    LDC  5,0(0) 	return zp 0
103:     LD  1,0(4) 	op: load left
104:    MUL  0,1,0 	op *
* <- Op
105:     ST  0,0(4) 	op: push left
106:    LDC  5,1(0) 	temp use zp for push
107:    ADD  4,4,5 	push stack address
108:    LDC  5,0(0) 	return zp 0
* -> Id
109:     LD  0,-4(3) 	load local id value
* <- Id
110:    LDC  5,1(0) 	temp use zp for pop
111:    SUB  4,4,5 	pop stack address
112:    LDC  5,0(0) 	return zp 0
113:     LD  1,0(4) 	op: load left
114:    DIV  0,1,0 	op /
* <- Op
115:     ST  0,0(4) 	op: push left
116:    LDC  5,1(0) 	temp use zp for push
117:    ADD  4,4,5 	push stack address
118:    LDC  5,0(0) 	return zp 0
* -> Id
119:     LD  0,-3(3) 	load local id value
* <- Id
120:    LDC  5,1(0) 	temp use zp for pop
121:    SUB  4,4,5 	pop stack address
122:    LDC  5,0(0) 	return zp 0
123:     LD  1,0(4) 	op: load left
124:    MUL  0,1,0 	op *
* <- Op
125:    LDC  5,1(0) 	temp use zp for pop
126:    SUB  4,4,5 	pop stack address
127:    LDC  5,0(0) 	return zp 0
128:     LD  1,0(4) 	op: load left
129:    ADD  0,1,0 	op +
* <- Op
130:     ST  0,0(4) 	op: push left
131:    LDC  5,1(0) 	temp use zp for push
132:    ADD  4,4,5 	push stack address
133:    LDC  5,0(0) 	return zp 0
* -> Id
134:     LD  0,-2(3) 	load local id value
* <- Id
135:    LDC  5,1(0) 	temp use zp for pop
136:    SUB  4,4,5 	pop stack address
137:    LDC  5,0(0) 	return zp 0
138:     LD  1,0(4) 	op: load left
139:    SUB  0,1,0 	op -
* <- Op
140:     ST  0,1(3) 	load local id value
* -> Id
141:     LD  0,1(3) 	load local id value
* <- Id
142:    OUT  0,0,0 	standard output
* -> assign
* function call use var or fun
* function call use var or fun
* function call use var or fun
* -> Id
143:     LD  0,-10(3) 	load local id value
* <- Id
144:     ST  0,0(4) 	insert parameter 
145:    LDC  5,1(0) 	temp use zp for push
146:    ADD  4,4,5 	push stack address
147:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* function call use var or fun
* -> Id
148:     LD  0,-9(3) 	load local id value
* <- Id
149:     ST  0,0(4) 	insert parameter 
150:    LDC  5,1(0) 	temp use zp for push
151:    ADD  4,4,5 	push stack address
152:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
153:     LD  0,-8(3) 	load local id value
* <- Id
154:     ST  0,0(4) 	insert parameter 
155:    LDC  5,1(0) 	temp use zp for push
156:    ADD  4,4,5 	push stack address
157:    LDC  5,0(0) 	return zp 0
158:     ST  3,0(4) 	save old fp
159:    LDC  5,1(0) 	temp use zp for push
160:    ADD  4,4,5 	push stack address
161:    LDC  5,0(0) 	return zp 0
162:    ADD  3,4,5 	sp->fp
163:    LDC  0,3(0) 	parameternum -> ac
164:     ST  0,0(4) 	save old sp
165:    LDC  5,1(0) 	temp use zp for push
166:    ADD  4,4,5 	push stack address
167:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
168:     LD  0,-3(3) 	load local id value
* <- Id
169:     ST  0,0(4) 	op: push left
170:    LDC  5,1(0) 	temp use zp for push
171:    ADD  4,4,5 	push stack address
172:    LDC  5,0(0) 	return zp 0
* -> Id
173:     LD  0,-2(3) 	load local id value
* <- Id
174:    LDC  5,1(0) 	temp use zp for pop
175:    SUB  4,4,5 	pop stack address
176:    LDC  5,0(0) 	return zp 0
177:     LD  1,0(4) 	op: load left
178:    SUB  0,1,0 	op -
* <- Op
179:    OUT  0,0,0 	standard output
* -> Op
* -> Id
180:     LD  0,-3(3) 	load local id value
* <- Id
181:     ST  0,0(4) 	op: push left
182:    LDC  5,1(0) 	temp use zp for push
183:    ADD  4,4,5 	push stack address
184:    LDC  5,0(0) 	return zp 0
* -> Id
185:     LD  0,-2(3) 	load local id value
* <- Id
186:    LDC  5,1(0) 	temp use zp for pop
187:    SUB  4,4,5 	pop stack address
188:    LDC  5,0(0) 	return zp 0
189:     LD  1,0(4) 	op: load left
190:    SUB  0,1,0 	op -
* <- Op
191:     LD  1,0(3) 	old sp ->ac
192:    SUB  4,3,1 	reset old sp
193:     LD  3,-1(3) 	reset old fp
194:     ST  0,0(4) 	insert parameter 
195:    LDC  5,1(0) 	temp use zp for push
196:    ADD  4,4,5 	push stack address
197:    LDC  5,0(0) 	return zp 0
198:     ST  3,0(4) 	save old fp
199:    LDC  5,1(0) 	temp use zp for push
200:    ADD  4,4,5 	push stack address
201:    LDC  5,0(0) 	return zp 0
202:    ADD  3,4,5 	sp->fp
203:    LDC  0,3(0) 	parameternum -> ac
204:     ST  0,0(4) 	save old sp
205:    LDC  5,1(0) 	temp use zp for push
206:    ADD  4,4,5 	push stack address
207:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
208:     LD  0,-3(3) 	load local id value
* <- Id
209:     ST  0,0(4) 	op: push left
210:    LDC  5,1(0) 	temp use zp for push
211:    ADD  4,4,5 	push stack address
212:    LDC  5,0(0) 	return zp 0
* -> Id
213:     LD  0,-2(3) 	load local id value
* <- Id
214:    LDC  5,1(0) 	temp use zp for pop
215:    SUB  4,4,5 	pop stack address
216:    LDC  5,0(0) 	return zp 0
217:     LD  1,0(4) 	op: load left
218:    ADD  0,1,0 	op +
* <- Op
219:    OUT  0,0,0 	standard output
* -> Op
* -> Id
220:     LD  0,-3(3) 	load local id value
* <- Id
221:     ST  0,0(4) 	op: push left
222:    LDC  5,1(0) 	temp use zp for push
223:    ADD  4,4,5 	push stack address
224:    LDC  5,0(0) 	return zp 0
* -> Id
225:     LD  0,-2(3) 	load local id value
* <- Id
226:    LDC  5,1(0) 	temp use zp for pop
227:    SUB  4,4,5 	pop stack address
228:    LDC  5,0(0) 	return zp 0
229:     LD  1,0(4) 	op: load left
230:    ADD  0,1,0 	op +
* <- Op
231:     LD  1,0(3) 	old sp ->ac
232:    SUB  4,3,1 	reset old sp
233:     LD  3,-1(3) 	reset old fp
234:     ST  0,0(4) 	insert parameter 
235:    LDC  5,1(0) 	temp use zp for push
236:    ADD  4,4,5 	push stack address
237:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* function call use var or fun
* function call use var or fun
* function call use var or fun
* -> Id
238:     LD  0,-6(3) 	load local id value
* <- Id
239:     ST  0,0(4) 	insert parameter 
240:    LDC  5,1(0) 	temp use zp for push
241:    ADD  4,4,5 	push stack address
242:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
243:     LD  0,-5(3) 	load local id value
* <- Id
244:     ST  0,0(4) 	insert parameter 
245:    LDC  5,1(0) 	temp use zp for push
246:    ADD  4,4,5 	push stack address
247:    LDC  5,0(0) 	return zp 0
248:     ST  3,0(4) 	save old fp
249:    LDC  5,1(0) 	temp use zp for push
250:    ADD  4,4,5 	push stack address
251:    LDC  5,0(0) 	return zp 0
252:    ADD  3,4,5 	sp->fp
253:    LDC  0,3(0) 	parameternum -> ac
254:     ST  0,0(4) 	save old sp
255:    LDC  5,1(0) 	temp use zp for push
256:    ADD  4,4,5 	push stack address
257:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
258:     LD  0,-3(3) 	load local id value
* <- Id
259:     ST  0,0(4) 	op: push left
260:    LDC  5,1(0) 	temp use zp for push
261:    ADD  4,4,5 	push stack address
262:    LDC  5,0(0) 	return zp 0
* -> Id
263:     LD  0,-2(3) 	load local id value
* <- Id
264:    LDC  5,1(0) 	temp use zp for pop
265:    SUB  4,4,5 	pop stack address
266:    LDC  5,0(0) 	return zp 0
267:     LD  1,0(4) 	op: load left
268:    MUL  0,1,0 	op *
* <- Op
269:    OUT  0,0,0 	standard output
* -> Op
* -> Id
270:     LD  0,-3(3) 	load local id value
* <- Id
271:     ST  0,0(4) 	op: push left
272:    LDC  5,1(0) 	temp use zp for push
273:    ADD  4,4,5 	push stack address
274:    LDC  5,0(0) 	return zp 0
* -> Id
275:     LD  0,-2(3) 	load local id value
* <- Id
276:    LDC  5,1(0) 	temp use zp for pop
277:    SUB  4,4,5 	pop stack address
278:    LDC  5,0(0) 	return zp 0
279:     LD  1,0(4) 	op: load left
280:    MUL  0,1,0 	op *
* <- Op
281:     LD  1,0(3) 	old sp ->ac
282:    SUB  4,3,1 	reset old sp
283:     LD  3,-1(3) 	reset old fp
284:     ST  0,0(4) 	insert parameter 
285:    LDC  5,1(0) 	temp use zp for push
286:    ADD  4,4,5 	push stack address
287:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
288:     LD  0,-4(3) 	load local id value
* <- Id
289:     ST  0,0(4) 	insert parameter 
290:    LDC  5,1(0) 	temp use zp for push
291:    ADD  4,4,5 	push stack address
292:    LDC  5,0(0) 	return zp 0
293:     ST  3,0(4) 	save old fp
294:    LDC  5,1(0) 	temp use zp for push
295:    ADD  4,4,5 	push stack address
296:    LDC  5,0(0) 	return zp 0
297:    ADD  3,4,5 	sp->fp
298:    LDC  0,3(0) 	parameternum -> ac
299:     ST  0,0(4) 	save old sp
300:    LDC  5,1(0) 	temp use zp for push
301:    ADD  4,4,5 	push stack address
302:    LDC  5,0(0) 	return zp 0
* -> Id
303:     LD  0,-3(3) 	load local id value
* <- Id
304:    OUT  0,0,0 	standard output
* -> Id
305:     LD  0,-2(3) 	load local id value
* <- Id
306:    OUT  0,0,0 	standard output
* -> Op
* -> Id
307:     LD  0,-3(3) 	load local id value
* <- Id
308:     ST  0,0(4) 	op: push left
309:    LDC  5,1(0) 	temp use zp for push
310:    ADD  4,4,5 	push stack address
311:    LDC  5,0(0) 	return zp 0
* -> Id
312:     LD  0,-2(3) 	load local id value
* <- Id
313:    LDC  5,1(0) 	temp use zp for pop
314:    SUB  4,4,5 	pop stack address
315:    LDC  5,0(0) 	return zp 0
316:     LD  1,0(4) 	op: load left
317:    DIV  0,1,0 	op /
* <- Op
318:    OUT  0,0,0 	standard output
* -> Op
* -> Id
319:     LD  0,-3(3) 	load local id value
* <- Id
320:     ST  0,0(4) 	op: push left
321:    LDC  5,1(0) 	temp use zp for push
322:    ADD  4,4,5 	push stack address
323:    LDC  5,0(0) 	return zp 0
* -> Id
324:     LD  0,-2(3) 	load local id value
* <- Id
325:    LDC  5,1(0) 	temp use zp for pop
326:    SUB  4,4,5 	pop stack address
327:    LDC  5,0(0) 	return zp 0
328:     LD  1,0(4) 	op: load left
329:    DIV  0,1,0 	op /
* <- Op
330:     LD  1,0(3) 	old sp ->ac
331:    SUB  4,3,1 	reset old sp
332:     LD  3,-1(3) 	reset old fp
333:     ST  0,0(4) 	insert parameter 
334:    LDC  5,1(0) 	temp use zp for push
335:    ADD  4,4,5 	push stack address
336:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
337:     LD  0,-3(3) 	load local id value
* <- Id
338:     ST  0,0(4) 	insert parameter 
339:    LDC  5,1(0) 	temp use zp for push
340:    ADD  4,4,5 	push stack address
341:    LDC  5,0(0) 	return zp 0
342:     ST  3,0(4) 	save old fp
343:    LDC  5,1(0) 	temp use zp for push
344:    ADD  4,4,5 	push stack address
345:    LDC  5,0(0) 	return zp 0
346:    ADD  3,4,5 	sp->fp
347:    LDC  0,3(0) 	parameternum -> ac
348:     ST  0,0(4) 	save old sp
349:    LDC  5,1(0) 	temp use zp for push
350:    ADD  4,4,5 	push stack address
351:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
352:     LD  0,-3(3) 	load local id value
* <- Id
353:     ST  0,0(4) 	op: push left
354:    LDC  5,1(0) 	temp use zp for push
355:    ADD  4,4,5 	push stack address
356:    LDC  5,0(0) 	return zp 0
* -> Id
357:     LD  0,-2(3) 	load local id value
* <- Id
358:    LDC  5,1(0) 	temp use zp for pop
359:    SUB  4,4,5 	pop stack address
360:    LDC  5,0(0) 	return zp 0
361:     LD  1,0(4) 	op: load left
362:    MUL  0,1,0 	op *
* <- Op
363:    OUT  0,0,0 	standard output
* -> Op
* -> Id
364:     LD  0,-3(3) 	load local id value
* <- Id
365:     ST  0,0(4) 	op: push left
366:    LDC  5,1(0) 	temp use zp for push
367:    ADD  4,4,5 	push stack address
368:    LDC  5,0(0) 	return zp 0
* -> Id
369:     LD  0,-2(3) 	load local id value
* <- Id
370:    LDC  5,1(0) 	temp use zp for pop
371:    SUB  4,4,5 	pop stack address
372:    LDC  5,0(0) 	return zp 0
373:     LD  1,0(4) 	op: load left
374:    MUL  0,1,0 	op *
* <- Op
375:     LD  1,0(3) 	old sp ->ac
376:    SUB  4,3,1 	reset old sp
377:     LD  3,-1(3) 	reset old fp
378:     ST  0,0(4) 	insert parameter 
379:    LDC  5,1(0) 	temp use zp for push
380:    ADD  4,4,5 	push stack address
381:    LDC  5,0(0) 	return zp 0
382:     ST  3,0(4) 	save old fp
383:    LDC  5,1(0) 	temp use zp for push
384:    ADD  4,4,5 	push stack address
385:    LDC  5,0(0) 	return zp 0
386:    ADD  3,4,5 	sp->fp
387:    LDC  0,3(0) 	parameternum -> ac
388:     ST  0,0(4) 	save old sp
389:    LDC  5,1(0) 	temp use zp for push
390:    ADD  4,4,5 	push stack address
391:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
392:     LD  0,-3(3) 	load local id value
* <- Id
393:     ST  0,0(4) 	op: push left
394:    LDC  5,1(0) 	temp use zp for push
395:    ADD  4,4,5 	push stack address
396:    LDC  5,0(0) 	return zp 0
* -> Id
397:     LD  0,-2(3) 	load local id value
* <- Id
398:    LDC  5,1(0) 	temp use zp for pop
399:    SUB  4,4,5 	pop stack address
400:    LDC  5,0(0) 	return zp 0
401:     LD  1,0(4) 	op: load left
402:    ADD  0,1,0 	op +
* <- Op
403:    OUT  0,0,0 	standard output
* -> Op
* -> Id
404:     LD  0,-3(3) 	load local id value
* <- Id
405:     ST  0,0(4) 	op: push left
406:    LDC  5,1(0) 	temp use zp for push
407:    ADD  4,4,5 	push stack address
408:    LDC  5,0(0) 	return zp 0
* -> Id
409:     LD  0,-2(3) 	load local id value
* <- Id
410:    LDC  5,1(0) 	temp use zp for pop
411:    SUB  4,4,5 	pop stack address
412:    LDC  5,0(0) 	return zp 0
413:     LD  1,0(4) 	op: load left
414:    ADD  0,1,0 	op +
* <- Op
415:     LD  1,0(3) 	old sp ->ac
416:    SUB  4,3,1 	reset old sp
417:     LD  3,-1(3) 	reset old fp
418:     ST  0,0(4) 	insert parameter 
419:    LDC  5,1(0) 	temp use zp for push
420:    ADD  4,4,5 	push stack address
421:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
422:     LD  0,-2(3) 	load local id value
* <- Id
423:     ST  0,0(4) 	insert parameter 
424:    LDC  5,1(0) 	temp use zp for push
425:    ADD  4,4,5 	push stack address
426:    LDC  5,0(0) 	return zp 0
427:     ST  3,0(4) 	save old fp
428:    LDC  5,1(0) 	temp use zp for push
429:    ADD  4,4,5 	push stack address
430:    LDC  5,0(0) 	return zp 0
431:    ADD  3,4,5 	sp->fp
432:    LDC  0,3(0) 	parameternum -> ac
433:     ST  0,0(4) 	save old sp
434:    LDC  5,1(0) 	temp use zp for push
435:    ADD  4,4,5 	push stack address
436:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
437:     LD  0,-3(3) 	load local id value
* <- Id
438:     ST  0,0(4) 	op: push left
439:    LDC  5,1(0) 	temp use zp for push
440:    ADD  4,4,5 	push stack address
441:    LDC  5,0(0) 	return zp 0
* -> Id
442:     LD  0,-2(3) 	load local id value
* <- Id
443:    LDC  5,1(0) 	temp use zp for pop
444:    SUB  4,4,5 	pop stack address
445:    LDC  5,0(0) 	return zp 0
446:     LD  1,0(4) 	op: load left
447:    SUB  0,1,0 	op -
* <- Op
448:    OUT  0,0,0 	standard output
* -> Op
* -> Id
449:     LD  0,-3(3) 	load local id value
* <- Id
450:     ST  0,0(4) 	op: push left
451:    LDC  5,1(0) 	temp use zp for push
452:    ADD  4,4,5 	push stack address
453:    LDC  5,0(0) 	return zp 0
* -> Id
454:     LD  0,-2(3) 	load local id value
* <- Id
455:    LDC  5,1(0) 	temp use zp for pop
456:    SUB  4,4,5 	pop stack address
457:    LDC  5,0(0) 	return zp 0
458:     LD  1,0(4) 	op: load left
459:    SUB  0,1,0 	op -
* <- Op
460:     LD  1,0(3) 	old sp ->ac
461:    SUB  4,3,1 	reset old sp
462:     LD  3,-1(3) 	reset old fp
463:     ST  0,2(3) 	load local id value
* -> Id
464:     LD  0,2(3) 	load local id value
* <- Id
465:    OUT  0,0,0 	standard output
* -> if
* if test start
* function call use var or fun
* -> Id
466:     LD  0,1(3) 	load local id value
* <- Id
467:     ST  0,0(4) 	insert parameter 
468:    LDC  5,1(0) 	temp use zp for push
469:    ADD  4,4,5 	push stack address
470:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
471:     LD  0,2(3) 	load local id value
* <- Id
472:     ST  0,0(4) 	insert parameter 
473:    LDC  5,1(0) 	temp use zp for push
474:    ADD  4,4,5 	push stack address
475:    LDC  5,0(0) 	return zp 0
476:     ST  3,0(4) 	save old fp
477:    LDC  5,1(0) 	temp use zp for push
478:    ADD  4,4,5 	push stack address
479:    LDC  5,0(0) 	return zp 0
480:    ADD  3,4,5 	sp->fp
481:    LDC  0,3(0) 	parameternum -> ac
482:     ST  0,0(4) 	save old sp
483:    LDC  5,1(0) 	temp use zp for push
484:    ADD  4,4,5 	push stack address
485:    LDC  5,0(0) 	return zp 0
* -> if
* if test start
* -> Op
* -> Id
486:     LD  0,-3(3) 	load local id value
* <- Id
487:     ST  0,0(4) 	op: push left
488:    LDC  5,1(0) 	temp use zp for push
489:    ADD  4,4,5 	push stack address
490:    LDC  5,0(0) 	return zp 0
* -> Id
491:     LD  0,-2(3) 	load local id value
* <- Id
492:    LDC  5,1(0) 	temp use zp for pop
493:    SUB  4,4,5 	pop stack address
494:    LDC  5,0(0) 	return zp 0
495:     LD  1,0(4) 	op: load left
496:    SUB  0,1,0 	op ==
497:    JEQ  0,2(7) 	br if true
498:    LDC  0,0(0) 	false case
499:    LDA  7,1(7) 	unconditional jmp
500:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> Const
502:    LDC  0,1(0) 	load const
* <- Const
* if true end
* if: jump to end belongs here
501:    JEQ  0,2(7) 	if: jmp to else
* if false start
* -> Const
504:    LDC  0,0(0) 	load const
* <- Const
* if false end
503:    LDA  7,1(7) 	jmp to end
* <- if
505:     LD  1,0(3) 	old sp ->ac
506:    SUB  4,3,1 	reset old sp
507:     LD  3,-1(3) 	reset old fp
* if test end
* if: jump to else belongs here
* if true start
* -> Const
509:    LDC  0,1(0) 	load const
* <- Const
* if true end
* if: jump to end belongs here
508:    JEQ  0,2(7) 	if: jmp to else
* if false start
* -> Const
511:    LDC  0,0(0) 	load const
* <- Const
* if false end
510:    LDA  7,1(7) 	jmp to end
* <- if
512:     LD  1,0(3) 	old sp ->ac
513:    SUB  4,3,1 	reset old sp
514:     LD  3,-1(3) 	reset old fp
515:    OUT  0,0,0 	standard output
* End of execution.
516:   HALT  0,0,0 	
