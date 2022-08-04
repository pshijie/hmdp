---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 72958.
--- DateTime: 2022/8/3 18:13
---

-- 1.参数列表
-- 1.1 优惠卷Id
local voucherId = ARGV[1]
-- 1.2 用户Id
local userId = ARGV[2]

-- 2.数据key
-- 2.1.库存key
local stockKey = 'seckill:stock:' .. voucherId
-- 2.2.订单key
local orderKey = 'seckill:order:' .. voucherId

-- 3.脚本业务
-- 3.1.判断库存是否充足
if (tonumber(redis.call('get', stockKey)) <= 0)
then
    -- 库存不足
    return 1
end
-- 3.2.判断当前用户是否对该优惠卷下过单(即userId是否在set集合中)
if (redis.call('sismember', orderKey, userId) == 1) then
    -- 存在则是重复下单
    return 2
end
-- 3.3.上述判断都不满足声明用户未下过单,开始扣减库存并保存该用户到set集合中
redis.call('incrby', stockKey, -1)
redis.call('sadd', orderKey, userId)
return 0