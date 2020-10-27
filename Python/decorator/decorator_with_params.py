import inspect

def type_assert(*ty_args, **ty_kwargs):
    def decorator(func):
        # A...
        # 獲取函數參數
        # pa = f_sig.parameters['a']
        # pa.name pa.kind pa.default
        func_sig = inspect.signature(func)
        # bind需要每個參數都綁定，bind_partial就可以支持部分綁定
        # bind_partial會返回一個arguments對象
        # .arguments即可獲得一個有序字典
        bind_type = func_sig.bind_partial(*ty_args, **ty_kwargs).arguments
        def wrap(*args, **kwargs):
            # B...
            for name, obj in func_sig.bind(*args, **kwargs).arguments.items():
                type_ = bind_type.get(name)
                if type_:
                    if not isinstance(obj, type_):
                        raise TypeError('%s must be %s' % (name, type_))
            return func(*args, **kwargs)
        return wrap
    return decorator

@type_assert(c=str)
def f(a, b, c):
    pass

f(5, 10, 5.3)