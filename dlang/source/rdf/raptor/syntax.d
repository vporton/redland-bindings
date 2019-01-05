module rdf.raptor.syntax;

import std.string;
import rdf.raptor.world;

enum SyntaxBitflags { Need_Base_URI = 1 }

// FIXME: D style IDs

private extern extern(C) {
    const(Syntax_Description_Record)* raptor_world_get_parser_description(RaptorWorldHandle *world,
                                                                          uint counter);
    const(Syntax_Description_Record)* raptor_world_get_serializer_description(RaptorWorldHandle *world,
                                                                              uint counter);
    int raptor_world_get_parsers_count(RaptorWorldHandle *world);
    int raptor_world_get_serializers_count(RaptorWorldHandle *world);
}

extern(C) struct Mime_Type_Q {
private:
    char* _mimeType;
    size_t _mimeTypeLen;
    char _Q;
public:
    @property string mimeType() { return _mimeType[0.._mimeTypeLen].idup; }
    @property byte Q() { return _Q; }
}

extern(C) struct Syntax_Description_Record {
private:
    char** Names;
    uint Names_Count;
    char* Label;
    Mime_Type_Q* Mime_Types;
    uint Mime_Types_Count;
    char** URI_Strings;
    uint URI_Strings_Count;
    SyntaxBitflags Flags;
public:
    @disable this(this);
    string name(uint index)
        in { assert(index < namesCount); }
        do {
            return Names[index].fromStringz.idup;
        }
    @property uint namesCount() { return Names_Count; }
    @property string label() { return Label.fromStringz.idup; }
    ref const mimeTypeInfo(uint index)
        in { assert(index < Mime_Types_Count); }
        do {
            return Mime_Types[index]; 
        }
    @property uint mimeTypesCount() { return Mime_Types_Count; }
    string uri(uint index)
        in { assert(index < URI_Strings_Count); }
        do {
            return URI_Strings[index].fromStringz.idup;
        }
    @property uint urisCount() { return URI_Strings_Count; }
    @property SyntaxBitflags flags() { return Flags; }
}

struct ParserDescriptionIterator {
private:
    RaptorWorldWithoutFinalize _world;
    uint _pos;
public:
    @property uint position() { return _pos; }
    @property const ref front() {
        return *raptor_world_get_parser_description(_world.handle, _pos);
    }
    @property bool empty() {
        return !raptor_world_get_parser_description(_world.handle, _pos);
    }
    void popFront()
        in { assert(_pos < raptor_world_get_parsers_count(_world.handle)); }
        do {
            ++_pos;
        }
}

struct SerializerDescriptionIterator {
private:
    RaptorWorldWithoutFinalize _world;
    uint _pos;
public:
    @property uint position() { return _pos; }
    @property const ref front() {
        return *raptor_world_get_serializer_description(_world.handle, _pos);
    }
    @property bool empty() {
        return !raptor_world_get_serializer_description(_world.handle, _pos);
    }
    void popFront()
        in { assert(_pos < raptor_world_get_serializers_count(_world.handle)); }
        do {
            ++_pos;
        }
}

// TODO: Stopped at Create_Parser_Descriptions_Iterator
