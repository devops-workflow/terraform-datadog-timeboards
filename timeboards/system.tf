
# https://www.terraform.io/docs/providers/datadog/r/timeboard.html

# Look at existing integration dashboard

# System (instance/host)
/* Metrics
system.cpu.guest
system.cpu.idle
system.cpu.interrupt
system.cpu.iowait
system.cpu.stolen
system.cpu.system
system.cpu.user
system.disk.free
system.disk.in_use
system.disk.read_time_pct
system.disk.total
system.disk.used
system.disk.write_time_pct
system.fs.file_handles.allocated
system.fs.file_handles.allocated_unused
system.fs.file_handles.in_use
system.fs.file_handles.max
system.fs.file_handles.used
system.fs.inodes.free
system.fs.inodes.in_use
system.fs.inodes.total
system.fs.inodes.used
system.io.avg_q_sz
system.io.avg_rq_sz
system.io.await
system.io.r_await
system.io.r_s
system.io.rkb_s
system.io.rrqm_s
system.io.svctm
system.io.util
system.io.w_await
system.io.w_s
system.io.wkb_s
system.io.wrqm_s
system.linux.MemoryUtilization
system.load.1
system.load.15
system.load.5
system.load.norm.1
system.load.norm.15
system.load.norm.5
system.mem.buffered
system.mem.cached
system.mem.committed
system.mem.free
system.mem.nonpaged
system.mem.page_tables
system.mem.paged
system.mem.pagefile.free
system.mem.pagefile.pct_free
system.mem.pagefile.total
system.mem.pagefile.used
system.mem.pct_usable
system.mem.shared
system.mem.slab
system.mem.total
system.mem.usable
system.mem.used
system.net.bytes_rcvd
system.net.bytes_sent
system.net.packets_in.count
system.net.packets_in.error
system.net.packets_out.count
system.net.packets_out.error
system.net.tcp.backlog_drops
system.net.tcp.failed_retransmits
system.net.tcp.in_segs
system.net.tcp.listen_drops
system.net.tcp.listen_overflows
system.net.tcp.out_segs
system.net.tcp.retrans_segs
system.net.udp.in_csum_errors
system.net.udp.in_datagrams
system.net.udp.in_errors
system.net.udp.no_ports
system.net.udp.out_datagrams
system.net.udp.rcv_buf_errors
system.net.udp.snd_buf_errors
system.proc.count
system.proc.queue_length
system.swap.cached
system.swap.free
system.swap.total
system.swap.used
system.uptime
*/
resource "datadog_timeboard" "default_instance_timeboard" {
  title       = "SAMPLE Instance Timeboard"
  description = "created using the Datadog provider in Terraform"
  read_only   = false

  graph {
    title       = "UPTIME"
    viz         = "query_value"
    autoscale   = true
    precision   = "2"

    request {
      q                   = "avg:system.uptime{$env,$server_type,$host} by {host}"
      aggregator          = "avg"
      type                = "null"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Load Averages 1-5-15"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "avg:system.load.1{$env,$server_type,$host} by {host}"
      type                = "line"
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:system.load.5{$env,$server_type,$host} by {host}"
      type                = "line"
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:system.load.15{$env,$server_type,$host} by {host}"
      type                = "line"
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "CPU usage (%)"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "max:system.cpu.idle{$env,$server_type,$host} by {host}, max:system.cpu.user{$env,$server_type,$host} by {host}, max:system.cpu.system{$env,$server_type,$host} by {host}, max:system.cpu.iowait{$env,$server_type,$host} by {host}, max:system.cpu.stolen{$env,$server_type,$host} by {host}, max:system.cpu.guest{$env,$server_type,$host} by {host}"
      aggregator          = "avg"
      type                = "area"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Process usage CPU (%)"
    viz         = "toplist"
    autoscale   = true

    request {
      q                   = "top(avg:system.processes.cpu.pct{$env,$server_type,$host} by {process_name}, 5, 'mean', 'desc')"
      conditional_format  = []
      style {
        palette = "dog_classic"
      }
    }
  }

  graph {
    title       = "Memory breakdown"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "avg:system.mem.total{$env,$server_type,$host} by {host}"
      aggregator          = "avg"
      type                = "area"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:system.mem.used{$env,$server_type,$host} by {host}"
      aggregator          = "avg"
      type                = "area"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Process usage Memory (%)"
    viz         = "toplist"
    autoscale   = true

    request {
      q                   = "top(avg:system.processes.mem.pct{$env,$server_type,$host} by {process_name}, 5, 'mean', 'desc')"
      conditional_format  = []
      style {
        palette = "dog_classic"
      }
    }
  }

  graph {
    title       = "Disk usage by device"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "avg:system.disk.total{$env,$server_type,$host,$device} by {host,device}"
      aggregator          = "avg"
      type                = "area"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:system.disk.used{$env,$server_type,$host,$device} by {host,device}"
      type                = "area"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Disk usage by device (%)"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "max:system.disk.in_use{$env,$server_type,$host,$device} by {host,device}*100"
      aggregator          = "avg"
      type                = "line"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Disk IO (bytes per sec)"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "avg:gcp.gce.instance.disk.read_bytes_count{$env,$server_type,$host,$device} by {host}.as_count()"
      aggregator          = "avg"
      type                = "line"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:gcp.gce.instance.disk.write_bytes_count{$env,$server_type,$host,$device} by {host}.as_count()"
      type                = "line"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  graph {
    title       = "Network traffic (bytes per sec)"
    viz         = "timeseries"
    autoscale   = true

    request {
      q                   = "avg:system.net.bytes_sent{$env,$server_type,$host} by {host}"
      type                = "line"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }

    request {
      q                   = "avg:system.net.bytes_rcvd{$env,$server_type,$host} by {host}"
      type                = "line"
      conditional_format  = []
      style {
        width   = "normal"
        palette = "dog_classic"
        type    = "solid"
      }
    }
  }

  template_variable {
    default = "*"
    prefix  = "env"
    name    = "env"
  }

  template_variable {
    default = "*"
    prefix  = "server_type"
    name    = "server_type"
  }

  template_variable {
    default = "*"
    prefix  = "host"
    name    = "host"
  }

  template_variable {
    default = "*"
    prefix  = "device"
    name    = "device"
  }
}
