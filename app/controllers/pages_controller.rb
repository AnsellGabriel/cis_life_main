class PagesController < ApplicationController
  def home
  end

  def coso
    @pie_chart_data1 = [
      ["Approved Claims", 150],
      ["Denied Claims", 54],
      ["Pending Claims", 123]
    ]

    min_value = 1_000_000  # 1 million
    max_value = 2_000_000  # 2 million
    step = 100_000

    random_number1 = min_value + (step * rand(((max_value - min_value) / step) + 1))
    random_number2 = min_value + (step * rand(((max_value - min_value) / step) + 1))
    
    @pie_chart_data2 = [
      ["Male", random_number1],
      ["Female", random_number2]
    ]

    @column_chart_data1 = [
      {
        name: "Premium",
        data: [
          ["John Doe", 900000],
          ["Jane Doe", 1500000],
          ["Richard Roe", 200000],
          ["Peter Parker", 5000000],
          ["Tony Stark", 2500000]
        ]
      },
      {
        name: "Claims",
        data: [
          ["John Doe", 150000],
          ["Jane Doe", 800000],
          ["Richard Roe", 700000],
          ["Peter Parker", 2000000],
          ["Tony Stark", 4000000]
        ]
      }
    ]


    @line_chart_data2 = [
     {
      name: "Premium",
      data: [
        ["January", 20000000],
        ["February",10040000],
        ["March",30000200],
        ["April",35000000],
        ["May",60000000],
        ["June",20400100],
        ["July",40120398],
        ["August",50002010],
        ["September",28172881],
        ["October",30560000],
        ["November",20102491],
        ["December",40123800]
      ]
     },
     {
      name: "Claims",
      data: [
        ["January", 10000000],
        ["February", 5000000],
        ["March", 20000100],
        ["April", 40123800],
        ["May", 39010765],
        ["June", 19920100],
        ["July", 8000000],
        ["August", 10202900],
        ["September", 15120890],
        ["October", 5000190],
        ["November", 19012400],
        ["December", 25012780]
      ]
     }
    ]

    @cause_chart = [
      ["Cardiovascular Diseases", 3890],
      ["Respiratory Diseases", 2077],
      ["Cancer/Carcinomas", 1931],
      ["Kidney Diseases", 1231],
      ["Cerebrovascular Diseases", 1207],
      ["Diabetes", 627],
      ["Liver Diseases", 419],
      ["Vehicular Accident", 339],
      ["Gastrointestinal Diseases", 239],
      ["Accidental Death", 134]
    ]
  end

  def president
    @coso_prem = [
      {
        name: "Jackelyn Ballena",
        data: [
          ["January", 1000000],
          ["February", 2000000],
          ["March", 3000000],
          ["April", 4000000],
          ["May", 50000000],
          ["June", 10000000],
          ["July", 9000100],
          ["August", 8190192],
          ["September", 11002980],
          ["October", 3000001],
          ["November", 23987100],
          ["December", 1040290]
        ]
        
      },
      {
        name: "Sylvia Quinesio",
        data: [
          ["January", 20000000],
          ["February",10040000],
          ["March",30000200],
          ["April",35000000],
          ["May",60000000],
          ["June",20400100],
          ["July",40120398],
          ["August",50002010],
          ["September",28172881],
          ["October",30560000],
          ["November",20102491],
          ["December",40123800]
        ]
      },
      {
        name: "Cecille Laguna",
        data: [
          ["January", 10000000],
          ["February", 5000000],
          ["March", 20000100],
          ["April", 40123800],
          ["May", 39010765],
          ["June", 19920100],
          ["July", 8000000],
          ["August", 30202900],
          ["September", 15120890],
          ["October", 5000190],
          ["November", 19012400],
          ["December", 25012780]
        ]
      }
    ]

    @claims_coso = [
      {
        name: "Jackelyn Ballena",
        data: [
          ["January", @coso_prem[0][:data][0][1] * 0.3],
          ["February", @coso_prem[0][:data][1][1] * 0.3],
          ["March", @coso_prem[0][:data][2][1] * 0.3],
          ["April", @coso_prem[0][:data][3][1] * 0.3],
          ["May", @coso_prem[0][:data][4][1] * 0.3],
          ["June", @coso_prem[0][:data][5][1] * 0.3],
          ["July", @coso_prem[0][:data][6][1] * 0.3],
          ["August", @coso_prem[0][:data][7][1] * 0.3],
          ["September", @coso_prem[0][:data][8][1] * 0.3],
          ["October", @coso_prem[0][:data][9][1] * 0.3],
          ["November", @coso_prem[0][:data][10][1] * 0.3],
          ["December", @coso_prem[0][:data][11][1] * 0.5]
        ]
      },
      {
        name: "Sylvia Quinesion",
        data: [
          ["January", @coso_prem[1][:data][0][1] * 0.3],
          ["February", @coso_prem[1][:data][1][1] * 0.3],
          ["March", @coso_prem[1][:data][2][1] * 0.3],
          ["April", @coso_prem[1][:data][3][1] * 0.3],
          ["May", @coso_prem[1][:data][4][1] * 0.3],
          ["June", @coso_prem[1][:data][5][1] * 0.3],
          ["July", @coso_prem[1][:data][6][1] * 0.3],
          ["August", @coso_prem[1][:data][7][1] * 0.3],
          ["September", @coso_prem[1][:data][8][1] * 0.3],
          ["October", @coso_prem[1][:data][9][1] * 0.3],
          ["November", @coso_prem[1][:data][10][1] * 0.3],
          ["December", @coso_prem[1][:data][11][1] * 0.3]
        ]
      },
      {
        name: "Cecille Laguna",
        data: [
          ["January", @coso_prem[2][:data][0][1] * 0.3],
          ["February", @coso_prem[2][:data][1][1] * 0.3],
          ["March", @coso_prem[2][:data][2][1] * 0.3],
          ["April", @coso_prem[2][:data][3][1] * 0.3],
          ["May", @coso_prem[2][:data][4][1] * 0.3],
          ["June", @coso_prem[2][:data][5][1] * 0.3],
          ["July", @coso_prem[2][:data][6][1] * 0.3],
          ["August", @coso_prem[2][:data][7][1] * 0.3],
          ["September", @coso_prem[2][:data][8][1] * 0.3],
          ["October", @coso_prem[2][:data][9][1] * 0.3],
          ["November", @coso_prem[2][:data][10][1] * 0.3],
          ["December", @coso_prem[2][:data][11][1] * 0.3]
        ]
      }
    ]

    @top_small = [
      {
        name: "St. Vincent Ferrer Parish MPC",
        data: [
          ["Net Premium", 1150517.57],
          ["Share Capital", 603555.24],
          ["Interest on Capital", 3078.13],
          ["Patronage Refund", 8601.80],
          ["Experience Refund", 17203.6]
        ]
      },
      {
        name: "Dao MPC",
        data: [
          ["Net Premium", 417251.37],
          ["Share Capital", 573865.21],
          ["Interest on Capital", 2926.71],
          ["Patronage Refund", 3119.56],
          ["Experience Refund", 6239.13]
        ]
      },
      {
        name: "Tao Management Service & MPC",
        data: [
          ["Net Premium", 354763.58],
          ["Share Capital", 296860.34],
          ["Interest on Capital", 1513.99],
          ["Patronage Refund", 2652.38],
          ["Experience Refund", 5304.75]
        ]
      },
      {
        name: "San Vicente Baguio MPC",
        data: [
          ["Net Premium", 219440.86],
          ["Share Capital", 100000],
          ["Interest on Capital", 510],
          ["Patronage Refund", 1640.64],
          ["Experience Refund", 3281.28]
        ]
      },
      {
        name: "BWDTECC",
        data: [
          ["Net Premium", 195916.85],
          ["Share Capital", 213132.63],
          ["Interest on Capital", 1086.98],
          ["Patronage Refund", 1464.76],
          ["Experience Refund", 2929.53]
        ]
      },
    ]
    # column_chart_data = params[:data_type] || 'Net Premium'
    data_type = case params[:data_type]
    when 1 then "Share Capital"
    when 2 then "Interest on Capital"
    when 3 then "Patronage Refund"
    when 4 then "Experience Refund"
    else
      "Net Premium"
    end
    column_chart_data = data_type || 'Net Premium'

    @chart_data = @top_small.map do |entry|
      {
        name: entry[:name],
        data: [[column_chart_data, entry[:data].find { |d| d[0] == column_chart_data }[1]]]
      }
    end

  end

  def update_charts
    @top_small = [
      {
        name: "St. Vincent Ferrer Parish MPC",
        data: [
          ["Net Premium", 1150517.57],
          ["Share Capital", 603555.24],
          ["Interest on Capital", 3078.13],
          ["Patronage Refund", 8601.80],
          ["Experience Refund", 17203.6]
        ]
      },
      {
        name: "Dao MPC",
        data: [
          ["Net Premium", 417251.37],
          ["Share Capital", 573865.21],
          ["Interest on Capital", 2926.71],
          ["Patronage Refund", 3119.56],
          ["Experience Refund", 6239.13]
        ]
      },
      {
        name: "Tao Management Service & MPC",
        data: [
          ["Net Premium", 354763.58],
          ["Share Capital", 296860.34],
          ["Interest on Capital", 1513.99],
          ["Patronage Refund", 2652.38],
          ["Experience Refund", 5304.75]
        ]
      },
      {
        name: "San Vicente Baguio MPC",
        data: [
          ["Net Premium", 219440.86],
          ["Share Capital", 100000],
          ["Interest on Capital", 510],
          ["Patronage Refund", 1640.64],
          ["Experience Refund", 3281.28]
        ]
      },
      {
        name: "BWDTECC",
        data: [
          ["Net Premium", 195916.85],
          ["Share Capital", 213132.63],
          ["Interest on Capital", 1086.98],
          ["Patronage Refund", 1464.76],
          ["Experience Refund", 2929.53]
        ]
      },
    ]
    
    data_type = case params[:data_type].to_i
    when 1 then "Share Capital"
    when 2 then "Interest on Capital"
    when 3 then "Patronage Refund"
    when 4 then "Experience Refund"
    else
      "Net Premium"
    end
        
    column_chart_data = data_type || 'Net Premium'
    @chart_data = @top_small.map do |entry|
      {
        name: entry[:name],
        data: [[column_chart_data, entry[:data].find { |d| d[0] == column_chart_data }[1]]]
      }
    end

    respond_to do |format|
      format.turbo_stream
    end
    
  end
  
end
