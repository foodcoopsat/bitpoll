import os

SECRET_KEY = "DummyKey"

FIELD_ENCRYPTION_KEY = "DummyKeyOnlyUsedForCompilingTheDockerImages="

PIPELINE_LOCAL = {}
PIPELINE_LOCAL['JS_COMPRESSOR'] = 'pipeline.compressors.uglifyjs.UglifyJSCompressor'
PIPELINE_LOCAL['CSS_COMPRESSOR'] = 'pipeline.compressors.cssmin.CSSMinCompressor'

INSTALLED_APPS_LOCAL = []
