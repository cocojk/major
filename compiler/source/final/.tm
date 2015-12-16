* TINY Compilation to TM Code
* File: .tm
* Standard prelude:
* End of standard prelude.
  0:    LDC  0,0(0) 	global variable store at ac
  1:     ST  0,0(2) 	global variable store at globaloff(gp)
  2:    LDC  5,1(0) 	temp use zp for push
  3:    ADD  4,4,5 	push stack address
  4:    LDC  5,0(0) 	return zp 0
  5:    LDC  0,0(0) 	global variable store at ac
  6:     ST  0,1(2) 	global variable store at globaloff(gp)
  7:    LDC  5,1(0) 	temp use zp for push
  8:    ADD  4,4,5 	push stack address
  9:    LDC  5,0(0) 	return zp 0
 10:    LDC  0,0(0) 	global variable store at ac
 11:     ST  0,2(2) 	global variable store at globaloff(gp)
 12:    LDC  5,1(0) 	temp use zp for push
 13:    ADD  4,4,5 	push stack address
 14:    LDC  5,0(0) 	return zp 0
 15:    LDC  0,0(0) 	global variable store at ac
 16:     ST  0,3(2) 	global variable store at globaloff(gp)
 17:    LDC  5,1(0) 	temp use zp for push
 18:    ADD  4,4,5 	push stack address
 19:    LDC  5,0(0) 	return zp 0
 20:    LDC  0,0(0) 	global variable store at ac
 21:     ST  0,4(2) 	global variable store at globaloff(gp)
 22:    LDC  5,1(0) 	temp use zp for push
 23:    ADD  4,4,5 	push stack address
 24:    LDC  5,0(0) 	return zp 0
 25:    LDC  0,0(0) 	global variable store at ac
 26:     ST  0,5(2) 	global variable store at globaloff(gp)
 27:    LDC  5,1(0) 	temp use zp for push
 28:    ADD  4,4,5 	push stack address
 29:    LDC  5,0(0) 	return zp 0
 30:    LDC  0,0(0) 	global variable store at ac
 31:     ST  0,6(2) 	global variable store at globaloff(gp)
 32:    LDC  5,1(0) 	temp use zp for push
 33:    ADD  4,4,5 	push stack address
 34:    LDC  5,0(0) 	return zp 0
 35:    LDC  0,0(0) 	global variable store at ac
 36:     ST  0,7(2) 	global variable store at globaloff(gp)
 37:    LDC  5,1(0) 	temp use zp for push
 38:    ADD  4,4,5 	push stack address
 39:    LDC  5,0(0) 	return zp 0
 40:    LDC  0,0(0) 	global variable store at ac
 41:     ST  0,8(2) 	global variable store at globaloff(gp)
 42:    LDC  5,1(0) 	temp use zp for push
 43:    ADD  4,4,5 	push stack address
 44:    LDC  5,0(0) 	return zp 0
 45:    LDC  0,0(0) 	global variable store at ac
 46:     ST  0,9(2) 	global variable store at globaloff(gp)
 47:    LDC  5,1(0) 	temp use zp for push
 48:    ADD  4,4,5 	push stack address
 49:    LDC  5,0(0) 	return zp 0
 50:    ADD  3,4,5 	move sp -> fp
 51:    LDC  0,0(0) 	local variable store at ac
 52:     ST  0,1(3) 	local variable store at localoff(fp)
 53:    LDC  5,1(0) 	temp use zp for push
 54:    ADD  4,4,5 	push stack address
 55:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Const
 56:    LDC  0,0(0) 	load const
* <- Const
 57:     ST  0,1(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
 58:     LD  0,1(3) 	load local id value
* <- Id
 59:     ST  0,0(4) 	op: push left
 60:    LDC  5,1(0) 	temp use zp for push
 61:    ADD  4,4,5 	push stack address
 62:    LDC  5,0(0) 	return zp 0
* -> Const
 63:    LDC  0,10(0) 	load const
* <- Const
 64:    LDC  5,1(0) 	temp use zp for pop
 65:    SUB  4,4,5 	pop stack address
 66:    LDC  5,0(0) 	return zp 0
 67:     LD  1,0(4) 	op: load left
 68:    SUB  0,1,0 	op <
 69:    JLT  0,2(7) 	br if true
 70:    LDC  0,0(0) 	false case
 71:    LDA  7,1(7) 	unconditional jmp
 72:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> assign
* -> Id
 74:     LD  0,1(3) 	load local id value
* <- Id
 75:    ADD  6,0,5 	move ac -> ip
 76:     IN  0,0,0 	standard input
 77:    LDC  1,0(0) 	load offset
 78:    ADD  6,6,1 	load offset+index
 79:    ADD  6,6,2 	load offset+index+gp
 80:     ST  0,0(6) 	load global idarray value
* -> assign
* -> Op
* -> Id
 81:     LD  0,1(3) 	load local id value
* <- Id
 82:     ST  0,0(4) 	op: push left
 83:    LDC  5,1(0) 	temp use zp for push
 84:    ADD  4,4,5 	push stack address
 85:    LDC  5,0(0) 	return zp 0
* -> Const
 86:    LDC  0,1(0) 	load const
* <- Const
 87:    LDC  5,1(0) 	temp use zp for pop
 88:    SUB  4,4,5 	pop stack address
 89:    LDC  5,0(0) 	return zp 0
 90:     LD  1,0(4) 	op: load left
 91:    ADD  0,1,0 	op +
* <- Op
 92:     ST  0,1(3) 	load local id value
* while end
 93:    LDA  7,58(5) 	return test
 73:    JEQ  0,20(7) 	while : jmp to false
* <- while
* function call use vararray
 94:     LD  0,0(2) 	load global array at ac
 95:     ST  0,0(4) 	insert array parameter 
 96:    LDC  5,1(0) 	temp use zp for push
 97:    ADD  4,4,5 	push stack address
 98:    LDC  5,0(0) 	return zp 0
 99:     LD  0,1(2) 	load global array at ac
100:     ST  0,0(4) 	insert array parameter 
101:    LDC  5,1(0) 	temp use zp for push
102:    ADD  4,4,5 	push stack address
103:    LDC  5,0(0) 	return zp 0
104:     LD  0,2(2) 	load global array at ac
105:     ST  0,0(4) 	insert array parameter 
106:    LDC  5,1(0) 	temp use zp for push
107:    ADD  4,4,5 	push stack address
108:    LDC  5,0(0) 	return zp 0
109:     LD  0,3(2) 	load global array at ac
110:     ST  0,0(4) 	insert array parameter 
111:    LDC  5,1(0) 	temp use zp for push
112:    ADD  4,4,5 	push stack address
113:    LDC  5,0(0) 	return zp 0
114:     LD  0,4(2) 	load global array at ac
115:     ST  0,0(4) 	insert array parameter 
116:    LDC  5,1(0) 	temp use zp for push
117:    ADD  4,4,5 	push stack address
118:    LDC  5,0(0) 	return zp 0
119:     LD  0,5(2) 	load global array at ac
120:     ST  0,0(4) 	insert array parameter 
121:    LDC  5,1(0) 	temp use zp for push
122:    ADD  4,4,5 	push stack address
123:    LDC  5,0(0) 	return zp 0
124:     LD  0,6(2) 	load global array at ac
125:     ST  0,0(4) 	insert array parameter 
126:    LDC  5,1(0) 	temp use zp for push
127:    ADD  4,4,5 	push stack address
128:    LDC  5,0(0) 	return zp 0
129:     LD  0,7(2) 	load global array at ac
130:     ST  0,0(4) 	insert array parameter 
131:    LDC  5,1(0) 	temp use zp for push
132:    ADD  4,4,5 	push stack address
133:    LDC  5,0(0) 	return zp 0
134:     LD  0,8(2) 	load global array at ac
135:     ST  0,0(4) 	insert array parameter 
136:    LDC  5,1(0) 	temp use zp for push
137:    ADD  4,4,5 	push stack address
138:    LDC  5,0(0) 	return zp 0
139:     LD  0,9(2) 	load global array at ac
140:     ST  0,0(4) 	insert array parameter 
141:    LDC  5,1(0) 	temp use zp for push
142:    ADD  4,4,5 	push stack address
143:    LDC  5,0(0) 	return zp 0
* -> Const
144:    LDC  0,0(0) 	load const
* <- Const
145:     ST  0,0(4) 	insert parameter 
146:    LDC  5,1(0) 	temp use zp for push
147:    ADD  4,4,5 	push stack address
148:    LDC  5,0(0) 	return zp 0
* -> Const
149:    LDC  0,10(0) 	load const
* <- Const
150:     ST  0,0(4) 	insert parameter 
151:    LDC  5,1(0) 	temp use zp for push
152:    ADD  4,4,5 	push stack address
153:    LDC  5,0(0) 	return zp 0
154:     ST  3,0(4) 	save old fp
155:    LDC  5,1(0) 	temp use zp for push
156:    ADD  4,4,5 	push stack address
157:    LDC  5,0(0) 	return zp 0
158:    ADD  3,4,5 	sp->fp
159:    LDC  0,13(0) 	parameternum -> ac
160:     ST  0,0(4) 	save old sp
161:    LDC  5,1(0) 	temp use zp for push
162:    ADD  4,4,5 	push stack address
163:    LDC  5,0(0) 	return zp 0
164:    LDC  0,0(0) 	local variable store at ac
165:     ST  0,2(3) 	local variable store at localoff(fp)
166:    LDC  5,1(0) 	temp use zp for push
167:    ADD  4,4,5 	push stack address
168:    LDC  5,0(0) 	return zp 0
169:    LDC  0,0(0) 	local variable store at ac
170:     ST  0,3(3) 	local variable store at localoff(fp)
171:    LDC  5,1(0) 	temp use zp for push
172:    ADD  4,4,5 	push stack address
173:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Id
174:     LD  0,-13(3) 	load local id value
* <- Id
175:     ST  0,2(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
176:     LD  0,2(3) 	load local id value
* <- Id
177:     ST  0,0(4) 	op: push left
178:    LDC  5,1(0) 	temp use zp for push
179:    ADD  4,4,5 	push stack address
180:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
181:     LD  0,-12(3) 	load local id value
* <- Id
182:     ST  0,0(4) 	op: push left
183:    LDC  5,1(0) 	temp use zp for push
184:    ADD  4,4,5 	push stack address
185:    LDC  5,0(0) 	return zp 0
* -> Const
186:    LDC  0,1(0) 	load const
* <- Const
187:    LDC  5,1(0) 	temp use zp for pop
188:    SUB  4,4,5 	pop stack address
189:    LDC  5,0(0) 	return zp 0
190:     LD  1,0(4) 	op: load left
191:    SUB  0,1,0 	op -
* <- Op
192:    LDC  5,1(0) 	temp use zp for pop
193:    SUB  4,4,5 	pop stack address
194:    LDC  5,0(0) 	return zp 0
195:     LD  1,0(4) 	op: load left
196:    SUB  0,1,0 	op <
197:    JLT  0,2(7) 	br if true
198:    LDC  0,0(0) 	false case
199:    LDA  7,1(7) 	unconditional jmp
200:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
202:    LDC  0,0(0) 	local variable store at ac
203:     ST  0,4(3) 	local variable store at localoff(fp)
204:    LDC  5,1(0) 	temp use zp for push
205:    ADD  4,4,5 	push stack address
206:    LDC  5,0(0) 	return zp 0
* -> assign
* function call use vararray
* function call use var or fun
* -> Id
207:     LD  0,2(3) 	load local id value
* <- Id
208:     ST  0,0(4) 	insert parameter 
209:    LDC  5,1(0) 	temp use zp for push
210:    ADD  4,4,5 	push stack address
211:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
212:     LD  0,-12(3) 	load local id value
* <- Id
213:     ST  0,0(4) 	insert parameter 
214:    LDC  5,1(0) 	temp use zp for push
215:    ADD  4,4,5 	push stack address
216:    LDC  5,0(0) 	return zp 0
217:     ST  3,0(4) 	save old fp
218:    LDC  5,1(0) 	temp use zp for push
219:    ADD  4,4,5 	push stack address
220:    LDC  5,0(0) 	return zp 0
221:    ADD  3,4,5 	sp->fp
222:    LDC  0,3(0) 	parameternum -> ac
223:     ST  0,0(4) 	save old sp
224:    LDC  5,1(0) 	temp use zp for push
225:    ADD  4,4,5 	push stack address
226:    LDC  5,0(0) 	return zp 0
227:    LDC  0,0(0) 	local variable store at ac
228:     ST  0,5(3) 	local variable store at localoff(fp)
229:    LDC  5,1(0) 	temp use zp for push
230:    ADD  4,4,5 	push stack address
231:    LDC  5,0(0) 	return zp 0
232:    LDC  0,0(0) 	local variable store at ac
233:     ST  0,6(3) 	local variable store at localoff(fp)
234:    LDC  5,1(0) 	temp use zp for push
235:    ADD  4,4,5 	push stack address
236:    LDC  5,0(0) 	return zp 0
237:    LDC  0,0(0) 	local variable store at ac
238:     ST  0,7(3) 	local variable store at localoff(fp)
239:    LDC  5,1(0) 	temp use zp for push
240:    ADD  4,4,5 	push stack address
241:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Id
242:     LD  0,-3(3) 	load local id value
* <- Id
243:     ST  0,7(3) 	load local id value
* -> assign
* -> Id
* -> Idarray
* -> Id
244:     LD  0,-3(3) 	load local id value
* <- Id
245:    LDC  1,-3(0) 	load index
246:    ADD  0,1,0 	op +
247:     LD  0,0(3) 	load global idarray value
* <- Idarray
248:     ST  0,6(3) 	load local id value
* -> assign
* -> Op
* -> Id
249:     LD  0,-3(3) 	load local id value
* <- Id
250:     ST  0,0(4) 	op: push left
251:    LDC  5,1(0) 	temp use zp for push
252:    ADD  4,4,5 	push stack address
253:    LDC  5,0(0) 	return zp 0
* -> Const
254:    LDC  0,1(0) 	load const
* <- Const
255:    LDC  5,1(0) 	temp use zp for pop
256:    SUB  4,4,5 	pop stack address
257:    LDC  5,0(0) 	return zp 0
258:     LD  1,0(4) 	op: load left
259:    ADD  0,1,0 	op +
* <- Op
260:     ST  0,5(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
261:     LD  0,5(3) 	load local id value
* <- Id
262:     ST  0,0(4) 	op: push left
263:    LDC  5,1(0) 	temp use zp for push
264:    ADD  4,4,5 	push stack address
265:    LDC  5,0(0) 	return zp 0
* -> Id
266:     LD  0,-2(3) 	load local id value
* <- Id
267:    LDC  5,1(0) 	temp use zp for pop
268:    SUB  4,4,5 	pop stack address
269:    LDC  5,0(0) 	return zp 0
270:     LD  1,0(4) 	op: load left
271:    SUB  0,1,0 	op <
272:    JLT  0,2(7) 	br if true
273:    LDC  0,0(0) 	false case
274:    LDA  7,1(7) 	unconditional jmp
275:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> if
* if test start
* -> Op
* -> Id
* -> Idarray
* -> Id
277:     LD  0,5(3) 	load local id value
* <- Id
278:    LDC  1,-3(0) 	load index
279:    ADD  0,1,0 	op +
280:     LD  0,0(3) 	load global idarray value
* <- Idarray
281:     ST  0,0(4) 	op: push left
282:    LDC  5,1(0) 	temp use zp for push
283:    ADD  4,4,5 	push stack address
284:    LDC  5,0(0) 	return zp 0
* -> Id
285:     LD  0,6(3) 	load local id value
* <- Id
286:    LDC  5,1(0) 	temp use zp for pop
287:    SUB  4,4,5 	pop stack address
288:    LDC  5,0(0) 	return zp 0
289:     LD  1,0(4) 	op: load left
290:    SUB  0,1,0 	op <
291:    JLT  0,2(7) 	br if true
292:    LDC  0,0(0) 	false case
293:    LDA  7,1(7) 	unconditional jmp
294:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> assign
* -> Id
* -> Idarray
* -> Id
296:     LD  0,5(3) 	load local id value
* <- Id
297:    LDC  1,-3(0) 	load index
298:    ADD  0,1,0 	op +
299:     LD  0,0(3) 	load global idarray value
* <- Idarray
300:     ST  0,6(3) 	load local id value
* -> assign
* -> Id
301:     LD  0,5(3) 	load local id value
* <- Id
302:     ST  0,7(3) 	load local id value
* if true end
* if: jump to end belongs here
295:    JEQ  0,8(7) 	if: jmp to else
* if false start
* if false end
303:    LDA  7,0(7) 	jmp to end
* <- if
* -> assign
* -> Op
* -> Id
304:     LD  0,5(3) 	load local id value
* <- Id
305:     ST  0,0(4) 	op: push left
306:    LDC  5,1(0) 	temp use zp for push
307:    ADD  4,4,5 	push stack address
308:    LDC  5,0(0) 	return zp 0
* -> Const
309:    LDC  0,1(0) 	load const
* <- Const
310:    LDC  5,1(0) 	temp use zp for pop
311:    SUB  4,4,5 	pop stack address
312:    LDC  5,0(0) 	return zp 0
313:     LD  1,0(4) 	op: load left
314:    ADD  0,1,0 	op +
* <- Op
315:     ST  0,5(3) 	load local id value
* while end
316:    LDA  7,261(5) 	return test
276:    JEQ  0,40(7) 	while : jmp to false
* <- while
* -> Id
317:     LD  0,7(3) 	load local id value
* <- Id
318:     LD  1,0(3) 	old sp ->ac
319:    SUB  4,3,1 	reset old sp
320:     LD  3,-1(3) 	reset old fp
321:     ST  0,3(3) 	load local id value
* -> assign
* -> Id
* -> Idarray
* -> Id
322:     LD  0,3(3) 	load local id value
* <- Id
323:    LDC  1,-13(0) 	load index
324:    ADD  0,1,0 	op +
325:     LD  0,0(3) 	load global idarray value
* <- Idarray
326:     ST  0,4(3) 	load local id value
* -> assign
* -> Id
327:     LD  0,3(3) 	load local id value
* <- Id
328:    ADD  6,0,5 	move ac -> ip
* -> Id
* -> Idarray
* -> Id
329:     LD  0,2(3) 	load local id value
* <- Id
330:    LDC  1,-13(0) 	load index
331:    ADD  0,1,0 	op +
332:     LD  0,0(3) 	load global idarray value
* <- Idarray
333:    LDC  1,-13(0) 	load offset
334:    ADD  6,6,1 	load offset+index
335:    ADD  6,6,3 	load offset+index+gp
336:     ST  0,0(6) 	load local idarray value
* -> assign
* -> Id
337:     LD  0,2(3) 	load local id value
* <- Id
338:    ADD  6,0,5 	move ac -> ip
* -> Id
339:     LD  0,4(3) 	load local id value
* <- Id
340:    LDC  1,-13(0) 	load offset
341:    ADD  6,6,1 	load offset+index
342:    ADD  6,6,3 	load offset+index+gp
343:     ST  0,0(6) 	load local idarray value
* -> assign
* -> Op
* -> Id
344:     LD  0,2(3) 	load local id value
* <- Id
345:     ST  0,0(4) 	op: push left
346:    LDC  5,1(0) 	temp use zp for push
347:    ADD  4,4,5 	push stack address
348:    LDC  5,0(0) 	return zp 0
* -> Const
349:    LDC  0,1(0) 	load const
* <- Const
350:    LDC  5,1(0) 	temp use zp for pop
351:    SUB  4,4,5 	pop stack address
352:    LDC  5,0(0) 	return zp 0
353:     LD  1,0(4) 	op: load left
354:    ADD  0,1,0 	op +
* <- Op
355:     ST  0,2(3) 	load local id value
* while end
356:    LDA  7,176(5) 	return test
201:    JEQ  0,155(7) 	while : jmp to false
* <- while
357:     LD  1,0(3) 	old sp ->ac
358:    SUB  4,3,1 	reset old sp
359:     LD  3,-1(3) 	reset old fp
* -> assign
* -> Const
360:    LDC  0,0(0) 	load const
* <- Const
361:     ST  0,1(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
362:     LD  0,1(3) 	load local id value
* <- Id
363:     ST  0,0(4) 	op: push left
364:    LDC  5,1(0) 	temp use zp for push
365:    ADD  4,4,5 	push stack address
366:    LDC  5,0(0) 	return zp 0
* -> Const
367:    LDC  0,10(0) 	load const
* <- Const
368:    LDC  5,1(0) 	temp use zp for pop
369:    SUB  4,4,5 	pop stack address
370:    LDC  5,0(0) 	return zp 0
371:     LD  1,0(4) 	op: load left
372:    SUB  0,1,0 	op <
373:    JLT  0,2(7) 	br if true
374:    LDC  0,0(0) 	false case
375:    LDA  7,1(7) 	unconditional jmp
376:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> Id
* -> Idarray
* -> Id
378:     LD  0,1(3) 	load local id value
* <- Id
379:    LDC  1,0(0) 	load index
380:    ADD  0,1,0 	op +
381:     LD  0,0(2) 	load global idarray value
* <- Idarray
382:    OUT  0,0,0 	standard output
* -> assign
* -> Op
* -> Id
383:     LD  0,1(3) 	load local id value
* <- Id
384:     ST  0,0(4) 	op: push left
385:    LDC  5,1(0) 	temp use zp for push
386:    ADD  4,4,5 	push stack address
387:    LDC  5,0(0) 	return zp 0
* -> Const
388:    LDC  0,1(0) 	load const
* <- Const
389:    LDC  5,1(0) 	temp use zp for pop
390:    SUB  4,4,5 	pop stack address
391:    LDC  5,0(0) 	return zp 0
392:     LD  1,0(4) 	op: load left
393:    ADD  0,1,0 	op +
* <- Op
394:     ST  0,1(3) 	load local id value
* while end
395:    LDA  7,362(5) 	return test
377:    JEQ  0,18(7) 	while : jmp to false
* <- while
* End of execution.
396:   HALT  0,0,0 	
