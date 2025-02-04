## Based on https://github.com/shawnlaffan/biodiverse/commit/4e81cdfe00ece0ccb08dcb2da86b0254eb98ad70

requires "Archive::Zip", "1.68";                   # added
requires "autovivification", "0.18";
requires "Class::Inspector", "1.36";               # version specified
requires "Clone", "0.46";                          # updated from 0.35
requires "Cpanel::JSON::XS", "4.37";               # updated from 3
requires "Crypt::Mode::CBC", "0.080";              # added
requires "Data::Compare", "1.29";                  # version specified
requires "Data::Recursive", "1.1.0";               # version specified
requires "Data::Structure::Util", "0.16";          # version specified
# requires "DBD::XBase", "1.08";                     # version specified
requires "Excel::ValueReader::XLSX", "1.15";       # version specified
requires "Exception::Class", "1.45";               # version specified
requires "Exporter::Easy", "0.18";                 # version specified
#  requires "Faster::Maths";                       # introduces and then disabled at 4e81cdfe
requires "File::BOM", "0.18";                      # version specified
requires "File::Find::Rule", "0.34";               # version specified
requires "Geo::Converter::dms2dd", "0.05";
requires "Geo::ShapeFile", "3.03",                 # updated from 3.00
requires "Geo::Shapefile::Writer", "0.006";        # added
requires "Getopt::Long::Descriptive", "0.114";     # version specified
requires "HTML::QuickTable", "1.12";               # version specified
requires "JSON::MaybeXS", "1.004005";              # updated from 1.003
requires "JSON::PP", "4.16";                       # updated
requires "List::MoreUtils", "0.430";               # updated from 0.425
requires "List::Unique::DeterministicOrder", "0.004";  # version specified
requires "List::Util", "1.63";                     # updated from 1.54
requires "Math::Polygon", "1.10";                  # version specified
requires "Math::Random::MT::Auto", "6.23";         # updated from 6.21
requires "OLE::Storage_Lite", "0.22";              # added
requires "parent";
# requires "Path::Class", "0.37";                  # version specified
requires "PDL::Stats", "0.83";                   # added
requires "Readonly", "2.05";                     # version specified
requires "Ref::Util", "0.204";                   # version specified
requires "Ref::Util::XS", "0.117";               # version specified
requires "Regexp::Common", "2017060201";         # version specified
requires "rlib", "0.02";                         # version specified
requires "Sereal", "5.004";                      # updated from 3
requires "Sort::Key", "1.33";                    # version specified
requires "Sort::Naturally", "1.03";              # added
requires "Spreadsheet::ParseExcel", "0.66";      # version specified
requires "Spreadsheet::ParseODS", "0.38";        # version specified
requires "Spreadsheet::ParseXLSX", "0.34";       # version specified
requires "Spreadsheet::Read", "0.90";            # updated from 0.82
requires "Spreadsheet::ReadSXC", "0.38";         # updated from 0.28
requires "Statistics::Descriptive", "3.0801";    # updated from 3.0608
requires "Statistics::Descriptive::PDL", "0.16"; # updated
requires "Statistics::Sampler::Multinomial", '1.02'; # updated from 1.00
requires "Text::CSV_XS", "1.53";                 # updated from 1.04
requires "Text::Fuzzy", "0.29";                  # version specified
requires "Text::Levenshtein", "0.15";            # added
requires "Text::Wrapper", "1.05";                # version specified
requires "Tree::R", "0.072";                     # version specified
requires "URI::Escape";
requires "URI::Escape::XS", "0.14"       ;       # version specified
requires "XML::Parser", "2.47";                  # added
requires "XML::Twig", "3.53";                    # added
requires "YAML::Syck", "1.34";                   # updated from 1.29

# requires "Data::DumpXML";
# requires "FFI::Platypus::Declare", "1.34";
# requires "Geo::GDAL::FFI", 0.11;  #  this will pick up the aliens
# suggests "Panda::Lib";

requires "Alien::Build", "2.84";                                  # added
requires "Alien::Build::Plugin::Cleanse::BuildDir", "0.06";       # added
requires "Alien::Build::Plugin::Decode::SourceForge", "0.02";     # added
requires "Alien::Build::Plugin::PkgConfig::PPWrapper", "0.03";    # added
# requires "Alien::Build::Plugin::Fetch::Cache";

# test_requires
requires "Data::Section::Simple", "0.07";       # version specified
requires "Devel::Symdump", "2.18";              # version specified
requires "File::Compare";
requires "Perl::Tidy";
requires "Scalar::Util::Numeric", "0.40";       # version specified
requires "Test2::Suite", "0.000159";            # version specified
requires "Test::Deep::NoTest", "1.204";         # version specified
requires "Test::Lib", "0.003";                  # version specified
requires "Test::TempDir::Tiny", "0.018";        # version specified

