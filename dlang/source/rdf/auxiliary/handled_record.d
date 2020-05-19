module rdf.auxiliary.handled_record;

class RDFException: Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
    this(string file = __FILE__, size_t line = __LINE__) {
        this("RDF error", file, line);
    }
}

class NullRDFException: RDFException {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
    this(string file = __FILE__, size_t line = __LINE__) {
        this("librdf null pointer exception", file, line);
    }
}

// struct Dummy;

mixin template WithoutFinalize(alias _Dummy,
                               alias _WithoutFinalize,
                               alias _WithFinalize,
                               alias _copier = null)
{
    import std.traits;

    alias Dummy = _Dummy;
    alias WithFinalize = _WithFinalize;
    alias copier = _copier;

    private _Dummy* ptr;
    // Use fromHandle() instead
    private this(_Dummy* ptr) nothrow @safe {
        this.ptr = ptr;
    }
    private this(const(_Dummy*) ptr) const nothrow @safe {
        this.ptr = ptr;
    }
    @property _Dummy* handle() const nothrow @trusted {
        return cast(_Dummy*)ptr;
    }
    static _WithoutFinalize fromHandle(const _Dummy* ptr) {
        return _WithoutFinalize(cast(_Dummy*)ptr);
    }
    static _WithoutFinalize fromNonnullHandle(const _Dummy* ptr) {
        if(!ptr) throw new NullRDFException();
        return _WithoutFinalize(cast(_Dummy*)ptr);
    }
    @property bool isNull() {
        return ptr == null;
    }
    static if(isCallable!_copier) {
        _WithFinalize dup() {
            return _WithFinalize( _copier(ptr));
        }
    }
    size_t toHash() const nothrow @safe {
        return cast(size_t) handle;
    }
}

mixin template WithFinalize(alias _Dummy,
                            alias _WithoutFinalize,
                            alias _WithFinalize,
                            alias _destructor,
                            alias _constructor = null)
{
    import std.traits;

    alias Dummy = _Dummy;
    alias WithoutFinalize = _WithoutFinalize;
    alias destructor = _destructor;
    alias constructor = _constructor;

    private _Dummy* ptr;
    @disable this();
    static if (isCallable!_constructor) {
        static _WithFinalize create() {
            return _WithFinalize( _constructor());
        }
    }
    @disable this(this);
    // Use fromHandle() instead
    private this(_Dummy* ptr) nothrow @safe {
        this.ptr = ptr;
    }
    private this(const _Dummy* ptr) const nothrow @safe {
        this.ptr = ptr;
    }
    ~this() {
        _destructor(ptr);
    }
    /*private*/ @property _WithoutFinalize base() nothrow @trusted { // private does not work in v2.081.2
        return _WithoutFinalize(ptr);
    }
    /*private*/ @property const(_WithoutFinalize) base() const nothrow @trusted { // private does not work in v2.081.2
        return const _WithoutFinalize(ptr);
    }
    alias base this;
    @property _Dummy* handle() const {
        return cast(_Dummy*)ptr;
    }
    static _WithFinalize fromHandle(const _Dummy* ptr) {
        return _WithFinalize(cast(_Dummy*)ptr);
    }
    static _WithFinalize fromNonnullHandle(const _Dummy* ptr) {
        if(!ptr) throw new NullRDFException();
        return _WithFinalize(cast(_Dummy*)ptr);
    }
    static if (__traits(compiles, _WithoutFinalize.opEquals)) {
        bool opEquals(const ref _WithFinalize s) const {
            return this.base.opEquals(s.base);
        }
        bool opEquals(const _WithoutFinalize s) const {
            return this.base.opEquals(s);
        }
    }
    static if (__traits(compiles, _WithoutFinalize.opCmp)) {
        int opCmp(const ref _WithFinalize s) const {
            return this.base.opEquals( s.base);
        }
        int opCmp(const _WithoutFinalize s) const {
            return this.base.opEquals( s);
        }
    }
    size_t toHash() const nothrow @safe {
        return base.toHash;
    }

    class HandleObject {
        alias WithFinalize = _WithFinalize;
        alias WithoutFinalize = _WithoutFinalize;
        private _WithoutFinalize obj;
        bool shouldFinalize;
        this(Dummy *ptr, bool _shouldFinalize) {
            obj = _WithoutFinalize(ptr);
            shouldFinalize = _shouldFinalize;
        }
        this(_WithoutFinalize from) {
            obj = from;
            shouldFinalize = false;
        }
        ~this() {
            if(shouldFinalize) _WithFinalize.destructor(obj.handle);
        }
        alias obj this;
    }
}

mixin template CompareHandles(alias equal, alias compare) {
    import std.traits;

    bool opEquals(const typeof(this) s) const {
        static if(isCallable!equal) {
            return equal(handle, s.handle) != 0;
        } else {
            return compare(handle, s.handle) == 0;
        }
    }
    static if(isCallable!compare) {
        int opCmp(const typeof(this) s) const {
            return compare( handle, s.handle);
        }
    }
}
