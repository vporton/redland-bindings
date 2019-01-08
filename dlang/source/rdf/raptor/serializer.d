module rdf.raptor.serializer;

import std.string;
import std.stdio : FILE, File;
import rdf.auxiliary.handled_record;
import rdf.raptor.uri;
import rdf.raptor.iostream;

struct SerializerHandle;

private extern extern(C) {
    void raptor_free_serializer(SerializerHandle* rdf_serializer);
    int raptor_serializer_start_to_iostream(SerializerHandle* rdf_serializer,
                                            URIHandle* uri,
                                            IOStreamHandle* iostream);
    int raptor_serializer_start_to_filename(SerializerHandle* rdf_serializer,
                                            const char *filename);
    int raptor_serializer_start_to_file_handle(SerializerHandle* rdf_serializer,
                                               URIHandle* uri,
                                               FILE *fh);
}

struct SerializerWithoutFinalize {
    mixin WithoutFinalize!(SerializerHandle,
                           SerializerWithoutFinalize,
                           Serializer);
    void startToIOStream(IOStreamWithoutFinalize stream,
                         URIWithoutFinalize uri = URIWithoutFinalize.fromHandle(null))
    {
        if(raptor_serializer_start_to_iostream(handle, uri.handle, stream.handle) != 0)
            throw new RDFException();
    }
    void startToFilename(string filename) {
        if(raptor_serializer_start_to_filename(handle, filename.toStringz) != 0)
            throw new RDFException();
    }
    // raptor_serializer_start_to_string() is deliberately not used.
    // Use StreamToString instead.
    void startToFilehandle(URIWithoutFinalize uri, File file) {
        if(raptor_serializer_start_to_file_handle(handle, uri.handle, file.getFP) != 0)
            throw new RDFException();
    }
}

struct Serializer {
    mixin WithFinalize!(SerializerHandle,
                        SerializerWithoutFinalize,
                        Serializer,
                        raptor_free_serializer);
}

// TODO: Stopped at Set_Namespace
