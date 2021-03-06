module rdf.raptor.constants;

import std.string;

private extern extern(C) immutable __gshared uint raptor_version_major;
private extern extern(C) immutable __gshared uint raptor_version_minor;
private extern extern(C) immutable __gshared uint raptor_version_release;
private extern extern(C) immutable __gshared uint raptor_version_decimal;

alias versionMajor   = raptor_version_major;
alias versionMinor   = raptor_version_minor;
alias versionRelease = raptor_version_release;
alias versionDecimal = raptor_version_decimal;

private extern extern(C) {
    immutable char* raptor_copyright_string;
    immutable char* raptor_home_url_string;
    immutable char* raptor_license_string;
    immutable char* raptor_short_copyright_string;
    immutable char* raptor_version_string;
    immutable char* raptor_owl_namespace_uri;
    immutable char* raptor_rdf_namespace_uri;
    immutable char* raptor_rdf_schema_namespace_uri;
    immutable char* raptor_xml_literal_datatype_uri_string;
    immutable char* raptor_xml_namespace_uri;
    immutable char* raptor_xmlschema_datatypes_namespace_uri;
}

string copyrightString() { return raptor_copyright_string.fromStringz; }
string homeURLString() { return raptor_home_url_string.fromStringz; }
string licenseString() { return raptor_license_string.fromStringz; }
string shortCopyrightString() { return raptor_short_copyright_string.fromStringz; }
string versionString() { return raptor_version_string.fromStringz; }
string owlNamespaceURI() { return raptor_owl_namespace_uri.fromStringz; }
string rdfNamespaceURI() { return raptor_rdf_namespace_uri[0..43]; }
string rdfSchemaNamespaceURI() { return raptor_rdf_schema_namespace_uri.fromStringz; }
string xmlLiteralDatatypeURIString() {
    return raptor_xml_literal_datatype_uri_string[0..53];
}
string xmlNamespaceURI() { return raptor_xml_namespace_uri.fromStringz; }
string xmlschemaDatatypesNamespaceURI() { return raptor_xmlschema_datatypes_namespace_uri.fromStringz; }

enum DomainType : ubyte { none = 0,
                          ioStream = 1,
                          namespace = 2,
                          parser = 3,
                          Qname = 4,
                          sax2 = 5,
                          serializer = 6,
                          term = 7,
                          turtle_Writer = 8,
                          uri = 9,
                          world = 10,
                          www = 11,
                          xmlWriter = 12 }

unittest {
    import std.conv;

    string combinedString =
        to!string(versionMajor) ~ '.' ~ to!string(versionMinor) ~ '.' ~ to!string(versionRelease);
    uint combinedDecimal =
        versionMajor * 10000 + versionMinor * 100 + versionRelease;
    assert(combinedString == versionString, "Combined version string");
    assert(combinedDecimal == versionDecimal, "Combined decimal version");
}

