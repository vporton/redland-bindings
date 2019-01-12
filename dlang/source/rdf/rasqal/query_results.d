module rdf.rasqal.query_results;

import std.string;
import rdf.auxiliary.handled_record;
import rdf.raptor.uri;
import rdf.raptor.statement;
import rdf.raptor.iostream;
import rdf.rasqal.literal;

struct QueryResultsHandle;

enum QueryResultsType { Bindings,
                        Boolean,
                        Graph,
                        Syntax,
                        Unknown }

private extern extern(C) {
    void rasqal_free_query_results(QueryResultsHandle* query_results);
    QueryResultsType rasqal_query_results_get_type(QueryResultsHandle* query_results);
    int rasqal_query_results_is_bindings(QueryResultsHandle* query_results);
    int rasqal_query_results_is_boolean(QueryResultsHandle* query_results);
    int rasqal_query_results_is_graph(QueryResultsHandle* query_results);
    int rasqal_query_results_is_syntax(QueryResultsHandle* query_results);
    int rasqal_query_results_finished(QueryResultsHandle* query_results);
    const(char*) rasqal_query_results_get_binding_name(QueryResultsHandle* query_results,
                                                       int offset);
    LiteralHandle* rasqal_query_results_get_binding_value(QueryResultsHandle* query_results,
                                                          int offset);
    LiteralHandle* rasqal_query_results_get_binding_value_by_name(QueryResultsHandle* query_results,
                                                                  const char *name);
    int rasqal_query_results_get_bindings_count(QueryResultsHandle* query_results);
    int rasqal_query_results_get_boolean(QueryResultsHandle* query_results);
    int rasqal_query_results_get_count(QueryResultsHandle* query_results);
    StatementHandle* rasqal_query_results_get_triple(QueryResultsHandle* query_results);
    int rasqal_query_results_next(QueryResultsHandle* query_results);
    int rasqal_query_results_next_triple(QueryResultsHandle* query_results);
    int rasqal_query_results_read(IOStreamHandle* iostr,
                                  QueryResultsHandle* results,
                                  const char *name,
                                  const char *mime_type,
                                  URIHandle* format_uri,
                                  URIHandle* base_uri);
    int rasqal_query_results_write(IOStreamHandle* iostr,
                                   QueryResultsHandle* results,
                                   const char *name,
                                   const char *mime_type,
                                   URIHandle* format_uri,
                                   URIHandle* base_uri);
    const(char*) rasqal_query_results_type_label(QueryResultsType type);
    int rasqal_query_results_rewind(QueryResultsHandle* results);
}

struct QueryResultsWithoutFinalize {
    mixin WithoutFinalize!(QueryResultsHandle,
                           QueryResultsWithoutFinalize,
                           QueryResults);
    @property QueryResultsType type() {
        return rasqal_query_results_get_type(handle);
    }
    @property bool isBindings() {
        return rasqal_query_results_is_bindings(handle) != 0;
    }
    @property bool isBoolean() {
        return rasqal_query_results_is_boolean(handle) != 0;
    }
    @property bool isGraph() {
        return rasqal_query_results_is_graph(handle) != 0;
    }
    @property bool isSyntax() {
        return rasqal_query_results_is_syntax(handle) != 0;
    }
    // function addRow is deliberately not implemented
    bool finished()
        in(isBindings() || isGraph())
    {
        return rasqal_query_results_finished(handle) != 0;
    }
    string getBindingName(uint offset)
        in(isBindings)
    {
        const char* ptr = rasqal_query_results_get_binding_name(handle, int(offset));
        if(!ptr) throw new RDFException();
        return ptr.fromStringz.idup;
    }
    LiteralWithoutFinalize getBindingValue(uint offset)
        in(isBindings)
    {
        return LiteralWithoutFinalize.fromNonnullHandle(
            rasqal_query_results_get_binding_value(handle, int(offset)));
    }
    LiteralWithoutFinalize getBindingValueByName(string name)
        in(isBindings)
    {
        return LiteralWithoutFinalize.fromNonnullHandle(
            rasqal_query_results_get_binding_value_by_name(handle, name.toStringz));
    }
    // rasqal_query_results_get_bindings() deliberately not implemented.
    // Use iterators instead.
    @property uint bindingsCount()
        in(isBindings)
    {
        int count = rasqal_query_results_get_bindings_count(handle);
        if(count < 0) throw new RDFException();
        return count;
    }
    @property bool boolean()
        in(isBoolean)
    {        int value = rasqal_query_results_get_boolean(handle);
        if(value < 0) throw new RDFException();
        return value != 0;
    }
    @property uint currentCount() {
        int value = rasqal_query_results_get_count(handle);
        if(value < 0) throw new RDFException();
        return value;
    }
    // TODO
    //@property QueryWithoutFinalize query()
    @property Statement triple() // TODO: In Ada it is Without_Finalize
        in(isGraph)
    {
        return Statement.fromNonnullHandle(rasqal_query_results_get_triple(handle));
    }
    // Deliberately not implemented:
    // getRowByOffset(uint offset)
    void next() {
        int res = rasqal_query_results_next(handle);
        //if(res != 0) throw new RDFException(); // Check is done by Finished procedure, not here
    }
    void nextTriple() {
        int res = rasqal_query_results_next_triple(handle);
        //if(res != 0) throw new RDFException(); // Check is done by Finished procedure, not here
    }
    void read(IOStreamWithoutFinalize stream,
              string formatName,
              string mimeType,
              URIWithoutFinalize formatURI,
              URIWithoutFinalize baseURI)
    {
        int res = rasqal_query_results_read(stream.handle,
                                            handle,
                                            formatName == "" ? null : formatName.toStringz,
                                            mimeType == "" ? null : mimeType.toStringz,
                                            formatURI.handle,
                                            baseURI.handle);
        if(res != 0) throw new RDFException();
    }
    void write(IOStreamWithoutFinalize stream,
               string formatName,
               string mimeType,
               URIWithoutFinalize formatURI,
               URIWithoutFinalize baseURI)
    {
        int res = rasqal_query_results_write(stream.handle,
                                             handle,
                                             formatName == "" ? null : formatName.toStringz,
                                             mimeType == "" ? null : mimeType.toStringz,
                                             formatURI.handle,
                                             baseURI.handle);
        if(res != 0) throw new RDFException();
    }
    void rewind() {
        if(rasqal_query_results_rewind(handle) != 0)
            throw new RDFException();
    }
}

struct QueryResults {
    mixin WithFinalize!(QueryResultsHandle,
                        QueryResultsWithoutFinalize,
                        QueryResults,
                        rasqal_free_query_results);
    // TODO:
//    QueryResults create(RasqalWorldWithoutFinalize world,
//                        QueryWithoutFinalize query,
//                        QueryResultType type)
//    {
//        return fromNonnullHandle(rasqal_new_query_results(world.handle, handle, type, null));
//    }
   // Not supported as of Rasqal 0.9.32
   // QueryResults(RasqalWorldWithoutFinalize world,
   //              QueryResultsType type,
   //              URITypeWithoutFinalize baseURI,
   //              string value)
}

string typeLabel(QueryResultsType type) {
    const char* ptr = rasqal_query_results_type_label(type);
    if(!ptr) throw new RDFException();
    return ptr.fromStringz.idup;
}

struct QueryResultsRange {
private:
    QueryResultsWithoutFinalize obj;
public:
    this(QueryResultsWithoutFinalize obj) {
        this.obj = obj;
    }
    QueryResultsRange front() { return this; } // return itself
    void popFront() { obj.next(); }

    string getBindingName(uint offset) {
        return obj.getBindingName(offset);
    }
    LiteralWithoutFinalize getBindingValue(uint offset) {
        return obj.getBindingValue(offset);
    }
    LiteralWithoutFinalize getBindingValueByName(string name) {
        return obj.getBindingValueByName(name);
    }}

struct QueryResultsTriplesRange {
private:
    QueryResultsWithoutFinalize obj;
public:
    this(QueryResultsWithoutFinalize obj) {
        this.obj = obj;
    }
    Statement front() { return triple(); }
    void popFront() { obj.nextTriple(); }
    Statement triple() { return obj.triple(); }}

// TODO: Stopped at Variables_Cursor

