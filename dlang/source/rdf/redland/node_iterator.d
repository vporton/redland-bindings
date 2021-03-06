module rdf.redland.node_iterator;

import rdf.auxiliary.handled_record;
import rdf.redland.world;
import rdf.redland.node;
import rdf.redland.iterator;

//struct NodeIteratorHandle;
alias NodeIteratorHandle = IteratorHandle;

private extern extern(C) {
    void librdf_free_iterator(NodeIteratorHandle* iterator);
    int librdf_iterator_end(NodeIteratorHandle* iterator);
    int librdf_iterator_next(NodeIteratorHandle* iterator);
    void* librdf_iterator_get_object(NodeIteratorHandle* iterator);
    //void* librdf_iterator_get_context(NodeIteratorHandle* iterator);
    //void* librdf_iterator_get_key(NodeIteratorHandle* iterator);
    //void* librdf_iterator_get_value(NodeIteratorHandle* iterator);
    NodeIteratorHandle* librdf_new_empty_iterator(RedlandWorldHandle* world);
}

struct NodeIteratorWithoutFinalize {
    mixin WithoutFinalize!(NodeIteratorHandle,
                           NodeIteratorWithoutFinalize,
                           NodeIterator);
    @property bool empty() const {
        return librdf_iterator_end(handle) != 0;
    }
    @property NodeWithoutFinalize front() const {
        return NodeWithoutFinalize.fromNonnullHandle(cast(NodeHandle*)objectInternal);
    }
    void popFront() {
        cast(void)librdf_iterator_next(handle);
    }
    @property void* objectInternal() const {
        return librdf_iterator_get_object(handle);
    }
    // librdf_iterator_add_map() not implemented
}

struct NodeIterator {
    mixin WithFinalize!(NodeIteratorHandle,
                        NodeIteratorWithoutFinalize,
                        NodeIterator,
                        librdf_free_iterator);
    static NodeIterator emptyIterator(RedlandWorldWithoutFinalize world) {
        return NodeIterator.fromNonnullHandle(librdf_new_empty_iterator(world.handle));
    }
}

