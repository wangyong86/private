# Trend Angles and Discovery Prompts

Use this matrix to build the internal coverage table before selecting signals. Combine one angle
with one workload and one evidence source; do not search only for product names.

| Angle | Mechanisms to search | Workloads | Example discovery prompts |
| --- | --- | --- | --- |
| System shape | lakehouse, vector/search, OLTP, stream, inference data plane boundaries | RAG, agent memory, real-time analytics, feature/training data | `inference data plane architecture`, `lakehouse vector search integration`, `agent memory storage system` |
| Storage and formats | Iceberg, Delta, Hudi, Lance, Parquet, Arrow, metadata pruning, schema evolution, tiering | multimodal data, object-store tables, mutable training data | `open table format multimodal data`, `metadata pruning object storage`, `mutable multimodal dataset format` |
| Execution | vectorized execution, SIMD, late materialization, pushdown, optimizer, code generation | analytical scans, joins, feature extraction, hybrid retrieval | `vectorized execution AI workload`, `late materialization multimodal`, `query optimizer retrieval filter` |
| Indexing and retrieval | HNSW, IVF, PQ/RQ, filtered search, hybrid retrieval, reranking, query routing | enterprise search, RAG, multimodal retrieval | `filtered vector search index`, `quantized ANN query-time precision`, `hybrid retrieval execution engine` |
| Streaming and incremental | CDC, stream-table duality, incremental view maintenance, continuous query, watermarks | online features, real-time RAG, operational analytics | `incremental view maintenance AI`, `streaming retrieval index update`, `CDC vector index consistency` |
| Protocols and interoperability | Arrow Flight, ADBC, DataFusion, cross-engine access, catalog APIs | federated analytics, portable data planes, lakehouse engines | `Arrow Flight AI data`, `ADBC lakehouse interoperability`, `DataFusion storage integration` |
| Inference operations | cache, memory layer, admission control, backpressure, autoscaling, tail latency, observability | agents, online inference, high-QPS retrieval | `inference cache data system`, `retrieval admission control`, `RAG query profiling tail latency` |
| Research and viewpoints | keynote, position paper, retrospective, benchmark artifact, systems thesis | emerging architectures and rejected approaches | `database systems keynote AI data`, `storage systems outlook`, `vector database benchmark artifact` |
| Adoption and negative space | migration, production case, open-source contribution, standards adoption, deferred source | real deployments and ecosystem convergence | `production migration lakehouse AI`, `open source vector search adoption`, `database interoperability case study` |

For each angle, record at least one checked source and whether it produced a qualifying signal. A
missing result is useful coverage evidence only when the source was actually checked.
