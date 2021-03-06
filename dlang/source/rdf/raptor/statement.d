module rdf.raptor.statement;

import std.string;
import std.stdio;
import rdf.auxiliary.handled_record;
import rdf.raptor.memory;
import rdf.raptor.world;
import rdf.raptor.term;
import rdf.raptor.iostream;

struct StatementHandle {
private:
    RaptorWorldHandle* _world;
    int _usage;
    TermHandle* _subject, _predicate, _object, _graph;
}

private extern extern(C) {
    StatementHandle* raptor_statement_copy(StatementHandle* statement);
    void raptor_free_statement(StatementHandle* statement);
    int raptor_statement_equals(const StatementHandle* s1, const StatementHandle* s2);
    int raptor_statement_compare(const StatementHandle* s1, const StatementHandle* s2);
    int raptor_statement_print(const StatementHandle* statement, FILE *stream);
    int raptor_statement_print_as_ntriples(const StatementHandle* statement, FILE *stream);
    int raptor_statement_ntriples_write(const StatementHandle* statement,
                                        IOStreamHandle *iostr,
                                        int write_graph_term);
    StatementHandle* raptor_new_statement(RaptorWorldHandle *world);
    StatementHandle* raptor_new_statement_from_nodes(RaptorWorldHandle* world,
                                                     TermHandle* subject,
                                                     TermHandle* predicate,
                                                     TermHandle* object,
                                                     TermHandle* graph);
    TermHandle* raptor_term_copy(TermHandle* term);
}

struct StatementWithoutFinalize {
    mixin WithoutFinalize!(StatementHandle,
                           StatementWithoutFinalize,
                           Statement,
                           raptor_statement_copy);
    mixin CompareHandles!(raptor_statement_equals, raptor_statement_compare);
    @property RaptorWorldWithoutFinalize world() const {
        return RaptorWorldWithoutFinalize.fromNonnullHandle(handle._world);
    }
    @property TermWithoutFinalize subject() const { return TermWithoutFinalize.fromHandle(handle._subject); }
    @property TermWithoutFinalize predicate() const { return TermWithoutFinalize.fromHandle(handle._predicate); }
    @property TermWithoutFinalize object() const { return TermWithoutFinalize.fromHandle(handle._object); }
    @property TermWithoutFinalize graph() const { return TermWithoutFinalize.fromHandle(handle._graph); }
    void print(File file) const {
        if(raptor_statement_print(handle, file.getFP))
            throw new IOStreamException();
    }
    void printAsNtriples(File file) const {
        if(raptor_statement_print_as_ntriples(handle, file.getFP))
            throw new IOStreamException();
    }
    // raptor_statement_init(), raptor_statement_clear() are not boound, because they are probably internal
    void ntriplesWrite(IOStreamWithoutFinalize stream, bool writeGraphTerm) const {
        if(raptor_statement_ntriples_write(handle, stream.handle, writeGraphTerm))
            throw new IOStreamException();
    }
}

struct Statement {
    mixin WithFinalize!(StatementHandle,
                        StatementWithoutFinalize,
                        Statement,
                        raptor_free_statement);
    static Statement create(RaptorWorldWithoutFinalize world) {
        return Statement.fromNonnullHandle(raptor_new_statement(world.handle));
    }
    /// Makes copies of the terms (unlike the C library)
    static Statement create(RaptorWorldWithoutFinalize world,
                            TermWithoutFinalize subject,
                            TermWithoutFinalize predicate,
                            TermWithoutFinalize object,
                            TermWithoutFinalize graph = TermWithoutFinalize.fromHandle(null))
    {
        StatementHandle* handle =
            raptor_new_statement_from_nodes(world.handle,
                                            raptor_term_copy(subject.handle),
                                            raptor_term_copy(predicate.handle),
                                            raptor_term_copy(object.handle),
                                            raptor_term_copy(graph.handle));
        return Statement.fromNonnullHandle(handle);
    }
}

unittest {
      RaptorWorld world = RaptorWorld.createAndOpen();

      string uri1 = "http://example.org/xyz";
      string uri2 = "http://example.org/qqq";
      string uri3 = "http://example.org/123";

      Term term1 = Term.fromURIString(world, uri1);
      Term term2 = Term.fromURIString(world, uri2);
      Term term3 = Term.fromURIString(world, uri3);

      Statement st = Statement.create(world, term1, term2, term3);
      assert(st.subject.toString   == '<' ~ uri1 ~ '>', "Subject matches");
      assert(st.predicate.toString == '<' ~ uri2 ~ '>', "Predicate matches");
      assert(st.object.toString    == '<' ~ uri3 ~ '>', "Object matches");
}

