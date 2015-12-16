* TINY Compilation to TM Code
* File: selSort.tm
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
 51:    LDC  5,1(0) 	temp use zp for push
 52:    ADD  4,4,5 	push stack address
 53:    LDC  5,0(0) 	return zp 0
 54:    LDC  0,0(0) 	local variable store at ac
 55:     ST  0,1(3) 	local variable store at localoff(fp)
 56:    LDC  5,1(0) 	temp use zp for push
 57:    ADD  4,4,5 	push stack address
 58:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Const
 59:    LDC  0,0(0) 	load const
* <- Const
 60:     ST  0,1(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
 61:     LD  0,1(3) 	load local id value
* <- Id
 62:     ST  0,0(4) 	op: push left
 63:    LDC  5,1(0) 	temp use zp for push
 64:    ADD  4,4,5 	push stack address
 65:    LDC  5,0(0) 	return zp 0
* -> Const
 66:    LDC  0,10(0) 	load const
* <- Const
 67:    LDC  5,1(0) 	temp use zp for pop
 68:    SUB  4,4,5 	pop stack address
 69:    LDC  5,0(0) 	return zp 0
 70:     LD  1,0(4) 	op: load left
 71:    SUB  0,1,0 	op <
 72:    JLT  0,2(7) 	br if true
 73:    LDC  0,0(0) 	false case
 74:    LDA  7,1(7) 	unconditional jmp
 75:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> assign
* idarray in index start
* -> Id
 77:     LD  0,1(3) 	load local id value
* <- Id
* idarray in index end
 78:    ADD  6,0,5 	move ac -> ip
* assign rvalue start
 79:     IN  0,0,0 	standard input
* assign rvalue end
 80:    LDC  1,0(0) 	load offset
 81:    ADD  6,6,1 	load offset+index
 82:    ADD  6,6,2 	load offset+index+gp
 83:     ST  0,0(6) 	load global idarray value
* -> assign
* -> Op
* -> Id
 84:     LD  0,1(3) 	load local id value
* <- Id
 85:     ST  0,0(4) 	op: push left
 86:    LDC  5,1(0) 	temp use zp for push
 87:    ADD  4,4,5 	push stack address
 88:    LDC  5,0(0) 	return zp 0
* -> Const
 89:    LDC  0,1(0) 	load const
* <- Const
 90:    LDC  5,1(0) 	temp use zp for pop
 91:    SUB  4,4,5 	pop stack address
 92:    LDC  5,0(0) 	return zp 0
 93:     LD  1,0(4) 	op: load left
 94:    ADD  0,1,0 	op +
* <- Op
 95:     ST  0,1(3) 	load local id value
* while end
 96:    LDA  7,61(5) 	return test
 76:    JEQ  0,20(7) 	while : jmp to false
* <- while
* function call use vararray
* no delclration parameter insert
* -> Const
 97:    LDC  0,0(0) 	load const
* <- Const
 98:     ST  0,0(4) 	insert parameter 
 99:    LDC  5,1(0) 	temp use zp for push
100:    ADD  4,4,5 	push stack address
101:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
102:    LDC  0,10(0) 	load const
* <- Const
103:     ST  0,0(4) 	insert parameter 
104:    LDC  5,1(0) 	temp use zp for push
105:    ADD  4,4,5 	push stack address
106:    LDC  5,0(0) 	return zp 0
107:     ST  3,0(4) 	save old fp
108:    LDC  5,1(0) 	temp use zp for push
109:    ADD  4,4,5 	push stack address
110:    LDC  5,0(0) 	return zp 0
111:    ADD  3,4,5 	sp->fp
112:    LDC  0,3(0) 	parameternum -> ac
113:     ST  0,0(4) 	save old sp
114:    LDC  5,1(0) 	temp use zp for push
115:    ADD  4,4,5 	push stack address
116:    LDC  5,0(0) 	return zp 0
117:    LDC  0,0(0) 	local variable store at ac
118:     ST  0,2(3) 	local variable store at localoff(fp)
119:    LDC  5,1(0) 	temp use zp for push
120:    ADD  4,4,5 	push stack address
121:    LDC  5,0(0) 	return zp 0
122:    LDC  0,0(0) 	local variable store at ac
123:     ST  0,3(3) 	local variable store at localoff(fp)
124:    LDC  5,1(0) 	temp use zp for push
125:    ADD  4,4,5 	push stack address
126:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Id
127:     LD  0,-3(3) 	load local id value
* <- Id
128:     ST  0,2(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
129:     LD  0,2(3) 	load local id value
* <- Id
130:     ST  0,0(4) 	op: push left
131:    LDC  5,1(0) 	temp use zp for push
132:    ADD  4,4,5 	push stack address
133:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Id
134:     LD  0,-2(3) 	load local id value
* <- Id
135:     ST  0,0(4) 	op: push left
136:    LDC  5,1(0) 	temp use zp for push
137:    ADD  4,4,5 	push stack address
138:    LDC  5,0(0) 	return zp 0
* -> Const
139:    LDC  0,1(0) 	load const
* <- Const
140:    LDC  5,1(0) 	temp use zp for pop
141:    SUB  4,4,5 	pop stack address
142:    LDC  5,0(0) 	return zp 0
143:     LD  1,0(4) 	op: load left
144:    SUB  0,1,0 	op -
* <- Op
145:    LDC  5,1(0) 	temp use zp for pop
146:    SUB  4,4,5 	pop stack address
147:    LDC  5,0(0) 	return zp 0
148:     LD  1,0(4) 	op: load left
149:    SUB  0,1,0 	op <
150:    JLT  0,2(7) 	br if true
151:    LDC  0,0(0) 	false case
152:    LDA  7,1(7) 	unconditional jmp
153:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
155:    LDC  0,0(0) 	local variable store at ac
156:     ST  0,4(3) 	local variable store at localoff(fp)
157:    LDC  5,1(0) 	temp use zp for push
158:    ADD  4,4,5 	push stack address
159:    LDC  5,0(0) 	return zp 0
* -> assign
* function call use vararray
* function call use var or fun
* -> Id
160:     LD  0,2(3) 	load local id value
* <- Id
161:     ST  0,0(4) 	insert parameter 
162:    LDC  5,1(0) 	temp use zp for push
163:    ADD  4,4,5 	push stack address
164:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
165:     LD  0,-2(3) 	load local id value
* <- Id
166:     ST  0,0(4) 	insert parameter 
167:    LDC  5,1(0) 	temp use zp for push
168:    ADD  4,4,5 	push stack address
169:    LDC  5,0(0) 	return zp 0
170:     ST  3,0(4) 	save old fp
171:    LDC  5,1(0) 	temp use zp for push
172:    ADD  4,4,5 	push stack address
173:    LDC  5,0(0) 	return zp 0
174:    ADD  3,4,5 	sp->fp
175:    LDC  0,3(0) 	parameternum -> ac
176:     ST  0,0(4) 	save old sp
177:    LDC  5,1(0) 	temp use zp for push
178:    ADD  4,4,5 	push stack address
179:    LDC  5,0(0) 	return zp 0
180:    LDC  0,0(0) 	local variable store at ac
181:     ST  0,5(3) 	local variable store at localoff(fp)
182:    LDC  5,1(0) 	temp use zp for push
183:    ADD  4,4,5 	push stack address
184:    LDC  5,0(0) 	return zp 0
185:    LDC  0,0(0) 	local variable store at ac
186:     ST  0,6(3) 	local variable store at localoff(fp)
187:    LDC  5,1(0) 	temp use zp for push
188:    ADD  4,4,5 	push stack address
189:    LDC  5,0(0) 	return zp 0
190:    LDC  0,0(0) 	local variable store at ac
191:     ST  0,7(3) 	local variable store at localoff(fp)
192:    LDC  5,1(0) 	temp use zp for push
193:    ADD  4,4,5 	push stack address
194:    LDC  5,0(0) 	return zp 0
* -> assign
* -> Id
195:     LD  0,-3(3) 	load local id value
* <- Id
196:     ST  0,7(3) 	load local id value
* -> assign
* -> Id
* -> Idarray
* -> Id
197:     LD  0,-3(3) 	load local id value
* <- Id
198:    LDC  1,0(0) 	load index
199:    ADD  0,1,0 	offset + index value
200:    ADD  0,0,2 	offset + index value + gp
201:     LD  0,0(0) 	load global idarray value
* <- Idarray
202:     ST  0,6(3) 	load local id value
* -> assign
* -> Op
* -> Id
203:     LD  0,-3(3) 	load local id value
* <- Id
204:     ST  0,0(4) 	op: push left
205:    LDC  5,1(0) 	temp use zp for push
206:    ADD  4,4,5 	push stack address
207:    LDC  5,0(0) 	return zp 0
* -> Const
208:    LDC  0,1(0) 	load const
* <- Const
209:    LDC  5,1(0) 	temp use zp for pop
210:    SUB  4,4,5 	pop stack address
211:    LDC  5,0(0) 	return zp 0
212:     LD  1,0(4) 	op: load left
213:    ADD  0,1,0 	op +
* <- Op
214:     ST  0,5(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
215:     LD  0,5(3) 	load local id value
* <- Id
216:     ST  0,0(4) 	op: push left
217:    LDC  5,1(0) 	temp use zp for push
218:    ADD  4,4,5 	push stack address
219:    LDC  5,0(0) 	return zp 0
* -> Id
220:     LD  0,-2(3) 	load local id value
* <- Id
221:    LDC  5,1(0) 	temp use zp for pop
222:    SUB  4,4,5 	pop stack address
223:    LDC  5,0(0) 	return zp 0
224:     LD  1,0(4) 	op: load left
225:    SUB  0,1,0 	op <
226:    JLT  0,2(7) 	br if true
227:    LDC  0,0(0) 	false case
228:    LDA  7,1(7) 	unconditional jmp
229:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> if
* if test start
* -> Op
* -> Id
* -> Idarray
* -> Id
231:     LD  0,5(3) 	load local id value
* <- Id
232:    LDC  1,0(0) 	load index
233:    ADD  0,1,0 	offset + index value
234:    ADD  0,0,2 	offset + index value + gp
235:     LD  0,0(0) 	load global idarray value
* <- Idarray
236:     ST  0,0(4) 	op: push left
237:    LDC  5,1(0) 	temp use zp for push
238:    ADD  4,4,5 	push stack address
239:    LDC  5,0(0) 	return zp 0
* -> Id
240:     LD  0,6(3) 	load local id value
* <- Id
241:    LDC  5,1(0) 	temp use zp for pop
242:    SUB  4,4,5 	pop stack address
243:    LDC  5,0(0) 	return zp 0
244:     LD  1,0(4) 	op: load left
245:    SUB  0,1,0 	op <
246:    JLT  0,2(7) 	br if true
247:    LDC  0,0(0) 	false case
248:    LDA  7,1(7) 	unconditional jmp
249:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> assign
* -> Id
* -> Idarray
* -> Id
251:     LD  0,5(3) 	load local id value
* <- Id
252:    LDC  1,0(0) 	load index
253:    ADD  0,1,0 	offset + index value
254:    ADD  0,0,2 	offset + index value + gp
255:     LD  0,0(0) 	load global idarray value
* <- Idarray
256:     ST  0,6(3) 	load local id value
* -> assign
* -> Id
257:     LD  0,5(3) 	load local id value
* <- Id
258:     ST  0,7(3) 	load local id value
* if true end
* if: jump to end belongs here
250:    JEQ  0,9(7) 	if: jmp to else
* if false start
* if false end
259:    LDA  7,0(7) 	jmp to end
* <- if
* -> assign
* -> Op
* -> Id
260:     LD  0,5(3) 	load local id value
* <- Id
261:     ST  0,0(4) 	op: push left
262:    LDC  5,1(0) 	temp use zp for push
263:    ADD  4,4,5 	push stack address
264:    LDC  5,0(0) 	return zp 0
* -> Const
265:    LDC  0,1(0) 	load const
* <- Const
266:    LDC  5,1(0) 	temp use zp for pop
267:    SUB  4,4,5 	pop stack address
268:    LDC  5,0(0) 	return zp 0
269:     LD  1,0(4) 	op: load left
270:    ADD  0,1,0 	op +
* <- Op
271:     ST  0,5(3) 	load local id value
* while end
272:    LDA  7,215(5) 	return test
230:    JEQ  0,42(7) 	while : jmp to false
* <- while
* -> Id
273:     LD  0,7(3) 	load local id value
* <- Id
274:     LD  1,0(3) 	old sp ->ac
275:    SUB  4,3,1 	reset old sp
276:     LD  3,-1(3) 	reset old fp
277:     ST  0,3(3) 	load local id value
* -> assign
* -> Id
* -> Idarray
* -> Id
278:     LD  0,3(3) 	load local id value
* <- Id
279:    LDC  1,0(0) 	load index
280:    ADD  0,1,0 	offset + index value
281:    ADD  0,0,2 	offset + index value + gp
282:     LD  0,0(0) 	load global idarray value
* <- Idarray
283:     ST  0,4(3) 	load local id value
* -> assign
* idarray in index start
* -> Id
284:     LD  0,3(3) 	load local id value
* <- Id
* idarray in index end
285:    ADD  6,0,5 	move ac -> ip
* assign rvalue start
* -> Id
* -> Idarray
* -> Id
286:     LD  0,2(3) 	load local id value
* <- Id
287:    LDC  1,0(0) 	load index
288:    ADD  0,1,0 	offset + index value
289:    ADD  0,0,2 	offset + index value + gp
290:     LD  0,0(0) 	load global idarray value
* <- Idarray
* assign rvalue end
291:    LDC  1,0(0) 	load offset
292:    ADD  6,6,1 	load offset+index
293:    ADD  6,6,2 	load offset+index+gp
294:     ST  0,0(6) 	load global idarray value
* -> assign
* idarray in index start
* -> Id
295:     LD  0,2(3) 	load local id value
* <- Id
* idarray in index end
296:    ADD  6,0,5 	move ac -> ip
* assign rvalue start
* -> Id
297:     LD  0,4(3) 	load local id value
* <- Id
* assign rvalue end
298:    LDC  1,0(0) 	load offset
299:    ADD  6,6,1 	load offset+index
300:    ADD  6,6,2 	load offset+index+gp
301:     ST  0,0(6) 	load global idarray value
* -> assign
* -> Op
* -> Id
302:     LD  0,2(3) 	load local id value
* <- Id
303:     ST  0,0(4) 	op: push left
304:    LDC  5,1(0) 	temp use zp for push
305:    ADD  4,4,5 	push stack address
306:    LDC  5,0(0) 	return zp 0
* -> Const
307:    LDC  0,1(0) 	load const
* <- Const
308:    LDC  5,1(0) 	temp use zp for pop
309:    SUB  4,4,5 	pop stack address
310:    LDC  5,0(0) 	return zp 0
311:     LD  1,0(4) 	op: load left
312:    ADD  0,1,0 	op +
* <- Op
313:     ST  0,2(3) 	load local id value
* while end
314:    LDA  7,129(5) 	return test
154:    JEQ  0,160(7) 	while : jmp to false
* <- while
315:     LD  1,0(3) 	old sp ->ac
316:    SUB  4,3,1 	reset old sp
317:     LD  3,-1(3) 	reset old fp
* -> assign
* -> Const
318:    LDC  0,0(0) 	load const
* <- Const
319:     ST  0,1(3) 	load local id value
* -> while
* while test start
* -> Op
* -> Id
320:     LD  0,1(3) 	load local id value
* <- Id
321:     ST  0,0(4) 	op: push left
322:    LDC  5,1(0) 	temp use zp for push
323:    ADD  4,4,5 	push stack address
324:    LDC  5,0(0) 	return zp 0
* -> Const
325:    LDC  0,10(0) 	load const
* <- Const
326:    LDC  5,1(0) 	temp use zp for pop
327:    SUB  4,4,5 	pop stack address
328:    LDC  5,0(0) 	return zp 0
329:     LD  1,0(4) 	op: load left
330:    SUB  0,1,0 	op <
331:    JLT  0,2(7) 	br if true
332:    LDC  0,0(0) 	false case
333:    LDA  7,1(7) 	unconditional jmp
334:    LDC  0,1(0) 	true case
* <- Op
* while test end
* while start
* -> Id
* -> Idarray
* -> Id
336:     LD  0,1(3) 	load local id value
* <- Id
337:    LDC  1,0(0) 	load index
338:    ADD  0,1,0 	offset + index value
339:    ADD  0,0,2 	offset + index value + gp
340:     LD  0,0(0) 	load global idarray value
* <- Idarray
341:    OUT  0,0,0 	standard output
* -> assign
* -> Op
* -> Id
342:     LD  0,1(3) 	load local id value
* <- Id
343:     ST  0,0(4) 	op: push left
344:    LDC  5,1(0) 	temp use zp for push
345:    ADD  4,4,5 	push stack address
346:    LDC  5,0(0) 	return zp 0
* -> Const
347:    LDC  0,1(0) 	load const
* <- Const
348:    LDC  5,1(0) 	temp use zp for pop
349:    SUB  4,4,5 	pop stack address
350:    LDC  5,0(0) 	return zp 0
351:     LD  1,0(4) 	op: load left
352:    ADD  0,1,0 	op +
* <- Op
353:     ST  0,1(3) 	load local id value
* while end
354:    LDA  7,320(5) 	return test
335:    JEQ  0,19(7) 	while : jmp to false
* <- while
* End of execution.
355:   HALT  0,0,0 	
