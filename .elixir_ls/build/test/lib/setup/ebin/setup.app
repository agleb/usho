{application,setup,
             [{description,"Generic setup application for Erlang-based systems"},
              {vsn,"2.0.2"},
              {registered,[]},
              {applications,[kernel,stdlib]},
              {mod,{setup_app,[]}},
              {start_phases,[{run_setup,[]}]},
              {env,[]},
              {maintainers,["Ulf Wiger"]},
              {licenses,["Apache 2.0"]},
              {links,[{"Github","https://github.com/uwiger/setup"}]},
              {files,["src","c_src","include","rebar.config.script","priv",
                      "rebar.config","rebar.lock","README*","readme*",
                      "LICENSE*","license*","NOTICE","Makefile"]},
              {modules,[setup,setup_app,setup_gen,setup_lib,setup_srv,
                        setup_sup]}]}.