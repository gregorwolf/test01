
 @cds.persistence.exists
entity SysMActiveStatements {
    host: Host;
    port: Port;
    connection_id: ConnectionId;
    statement_id: StatementId;
    statement_hash: StatementHash;
    start_mvcc_timestamp: StartMvccTimestamp;
    compiled_time: CompiledTime;
    statement_status: StatementStatus;
    statement_string: StatementString;
    allocated_memory_size: AllocatedMemorySize;
    plan_id: PlanId;
    last_executed_time: LastExecutedTime;
    last_action_time: LastActionTime;
    recompile_count: RecompileCount;
    execution_count: ExecutionCount;
    avg_execution_time: AvgExecutionTime;
    max_execution_time: MaxExecutionTime;
    min_execution_time: MinExecutionTime;
    // ...
}

type Host: String(64) @title: 'Host';
type Port: Integer @title: 'Port';
type ConnectionId: Integer @title: 'Connection ID';
type StatementId: String(20) @title: 'Statement ID';
type StatementHash: String(32) @title: 'Statement Hash';
type StartMvccTimestamp: Integer64 @title: 'Start Mvcc Timestamp';
type CompiledTime: Timestamp @title: 'Compilation Time';
type StatementStatus: String(128) @title: 'Statement Status';
type StatementString: LargeString @title: 'Statement String';
type AllocatedMemorySize: Integer64 @title: 'Allocated Memory Size';
type PlanId: Integer64 @title: 'Plan ID';
type LastExecutedTime: Timestamp @title: 'Last Executed Time';
type LastActionTime: Timestamp @title: 'Last Action Time';
type RecompileCount: Integer64 @title: 'Recompile Count';
type ExecutionCount: Integer64 @title: 'Execution Count';
type AvgExecutionTime: Integer64 @title: 'Average Execution Time';
type MaxExecutionTime: Integer64 @title: 'Maximum Execution Time';
type MinExecutionTime: Integer64 @title: 'Minimum Execution Time';

