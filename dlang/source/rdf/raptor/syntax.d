module rdf.raptor.syntax;

import std.string;
import rdf.raptor.world;
import rdf.raptor.uri;

enum SyntaxBitflags { Need_Base_URI = 1 }

private extern extern(C) {
    const(SyntaxDescription)* raptor_world_get_parser_description(RaptorWorldHandle* world,
                                                                          uint counter);
    const(SyntaxDescription)* raptor_world_get_serializer_description(RaptorWorldHandle* world,
                                                                              uint counter);
    int raptor_world_get_parsers_count(RaptorWorldHandle* world);
    int raptor_world_get_serializers_count(RaptorWorldHandle* world);
    int raptor_world_is_parser_name(RaptorWorldHandle* world, const char *name);
    int raptor_world_is_serializer_name(RaptorWorldHandle* world, const char *name);
    immutable(char*) raptor_world_guess_parser_name(RaptorWorldHandle* world,
                                                    URIHandle* uri,
                                                    const char *mime_type,
                                                    const char *buffer,
                                                    size_t len,
                                                    const char *identifier);
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

extern(C) struct SyntaxDescription {
private:
    char** _names;
    uint _namesCount;
    char* _label;
    Mime_Type_Q* _mimeTypes;
    uint _mimeTypesCount;
    char** uriStrings;
    uint uriStringsCount;
    SyntaxBitflags _flags;
public:
    @disable this(this);
    string name(uint index)
        in { assert(index < namesCount); }
        do {
            return _names[index].fromStringz.idup;
        }
    @property uint namesCount() { return _namesCount; }
    @property string label() { return _label.fromStringz.idup; }
    ref const mimeTypeInfo(uint index)
        in { assert(index < _mimeTypesCount); }
        do {
            return _mimeTypes[index]; 
        }
    @property uint mimeTypesCount() { return _mimeTypesCount; }
    string uri(uint index)
        in { assert(index < uriStringsCount); }
        do {
            return uriStrings[index].fromStringz.idup;
        }
    @property uint urisCount() { return uriStringsCount; }
    @property SyntaxBitflags flags() { return _flags; }
}

struct ParserDescriptionIterator {
private:
    RaptorWorldWithoutFinalize _world;
    uint _pos = 0;
public:
    this(RaptorWorldWithoutFinalize world) {
        this._world = world;
    }
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
    uint _pos = 0;
public:
    this(RaptorWorldWithoutFinalize world) {
        this._world = world;
    }
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

bool isParserName(RaptorWorldWithoutFinalize world, string name) {
    return raptor_world_is_parser_name(world.handle, name.toStringz) != 0;
}

bool isSerializerName(RaptorWorldWithoutFinalize world, string name) {
    return raptor_world_is_serializer_name(world.handle, name.toStringz) != 0;
}

string guessParserName(RaptorWorldWithoutFinalize world,
                       URIWithoutFinalize uri,
                       string mimeType,
                       string buffer,
                       string identifier)
{
    immutable char* str = raptor_world_guess_parser_name(world.handle,
                                                         uri.handle,
                                                         mimeType.toStringz,
                                                         buffer.ptr,
                                                         buffer.length,
                                                         identifier.toStringz);
    // I don't use .idup because it is valid as long as the world exists
    return str.fromStringz;
}

// TODO: Stopped at Create_Parser_Descriptions_Iterator