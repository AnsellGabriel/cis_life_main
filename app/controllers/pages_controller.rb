class PagesController < ApplicationController
  before_action :set_gender_chart, only: %i[ coso president coop ]

  def home
  end

  def coso
    @pie_chart_data1 = [
      ["Approved Claims", 150],
      ["Denied Claims", 54],
      ["Pending Claims", 123]
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

    @total_claims_filed = [
      {
        name: "Approved Claims",
        data: [
        ["January", rand(20..100)],
        ["February", rand(20..50)],
        ["March", rand(50..100)],
        ["April", rand(50..100)],
        ["May", rand(50..100)],
        ["June", rand(20..40)],
        ["July", rand(80..100)],
        ["August", rand(50..100)],
        ["September", rand(50..100)],
        ["October", rand(50..100)],
        ["November", rand(50..100)],
        ["December", rand(50..100)]
        ]
      },
      {
        name: "Pending Claims",
        data: [
        ["January", rand(10..25)],
        ["February", rand(15..50)],
        ["March", rand(20..100)],
        ["April", rand(30..100)],
        ["May", rand(10..100)],
        ["June", rand(30..40)],
        ["July", rand(30..100)],
        ["August", rand(30..100)],
        ["September", rand(20..60)],
        ["October", rand(10..50)],
        ["November", rand(10..20)],
        ["December", rand(30..40)]
        ]
      },
      {
        name: "Denied Claims",
        data: [
        ["January", rand(3..10)],
        ["February", rand(15..20)],
        ["March", rand(1..10)],
        ["April", rand(1..10)],
        ["May", rand(10..30)],
        ["June", rand(30..50)],
        ["July", rand(30..50)],
        ["August", rand(10..20)],
        ["September", rand(20..60)],
        ["October", rand(10..50)],
        ["November", rand(30..50)],
        ["December", rand(10..30)]
        ]
      }
    ]

    
  end

  def president
    @coso_prem = [
      {
        name: "Luzon",
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
        name: "Visayas",
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
        name: "Mindanao",
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
        name: "Luzon",
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
        name: "Visayas",
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
        name: "Mindanao",
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
    # data_type = case params[:data_type]
    # when 1 then "Share Capital"
    # when 2 then "Interest on Capital"
    # when 3 then "Patronage Refund"
    # when 4 then "Experience Refund"
    # else
    #   "Net Premium"
    # end
    # column_chart_data = data_type || 'Net Premium'

    # @chart_data = @top_small.map do |entry|
    #   {
    #     name: entry[:name],
    #     data: [[column_chart_data, entry[:data].find { |d| d[0] == column_chart_data }[1]]]
    #   }
    # end

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

  def coop
    @prem_v_claims = [
      ["Premium", 5128317],
      ["Claims", 2192800]
    ]


    @prem_per_gr = GroupRemit.where(type: "Remittance", net_premium: 0..).pluck(:name, :net_premium)
    # @prem_per_gr = GroupRemit.where(type: "Remittance").pluck(:name, :net_premium).map { |name, net_premium| [name, net_premium || 0] }
    @claims_per_gr = GroupRemit.where(type: "Remittance", net_premium: 0..).pluck(:name, :net_premium).map { |name, premium| [name, premium * (rand(0.3..0.6))] }

  end

  def update_charts
    # @top = [
    #   {
    #     name: "St. Vincent Ferrer Parish MPC",
    #     data: [
    #       ["Net Premium", 1150517.57],
    #       ["Share Capital", 603555.24],
    #       ["Interest on Capital", 3078.13],
    #       ["Patronage Refund", 8601.80],
    #       ["Experience Refund", 17203.6]
    #     ]
    #   },
    #   {
    #     name: "Dao MPC",
    #     data: [
    #       ["Net Premium", 417251.37],
    #       ["Share Capital", 573865.21],
    #       ["Interest on Capital", 2926.71],
    #       ["Patronage Refund", 3119.56],
    #       ["Experience Refund", 6239.13]
    #     ]
    #   },
    #   {
    #     name: "Tao Management Service & MPC",
    #     data: [
    #       ["Net Premium", 354763.58],
    #       ["Share Capital", 296860.34],
    #       ["Interest on Capital", 1513.99],
    #       ["Patronage Refund", 2652.38],
    #       ["Experience Refund", 5304.75]
    #     ]
    #   },
    #   {
    #     name: "San Vicente Baguio MPC",
    #     data: [
    #       ["Net Premium", 219440.86],
    #       ["Share Capital", 100000],
    #       ["Interest on Capital", 510],
    #       ["Patronage Refund", 1640.64],
    #       ["Experience Refund", 3281.28]
    #     ]
    #   },
    #   {
    #     name: "BWDTECC",
    #     data: [
    #       ["Net Premium", 195916.85],
    #       ["Share Capital", 213132.63],
    #       ["Interest on Capital", 1086.98],
    #       ["Patronage Refund", 1464.76],
    #       ["Experience Refund", 2929.53]
    #     ]
    #   },
    # ]
    
    # data_type = case params[:data_type].to_i
    # when 1 then "Share Capital"
    # when 2 then "Interest on Capital"
    # when 3 then "Patronage Refund"
    # when 4 then "Experience Refund"
    # else
    #   "Net Premium"
    # end
        
    # column_chart_data = data_type || 'Net Premium'
    # @chart_data = @top_small.map do |entry|
    #   {
    #     name: entry[:name],
    #     data: [[column_chart_data, entry[:data].find { |d| d[0] == column_chart_data }[1]]]
    #   }
    # end

    if params[:data_type].to_i == 0
      @top = [
        ["St. Vincent Ferrer Parish MPC", 1150517.57],
        ["Dao MPC", 417251.37],
        ["Tao Management Service & MPC", 354763.58],
        ["San Vicente Baguio MPC", 219440.86],
        ["Bayugan West District Teachers Employees Community Cooperative", 195916.85],
        ["Opol Employees MPC", 146339.3],
        ["Murphy Development Cooperative", 103890.10],
        ["Surigao del Sur Police Cooperative", 74555.67],
        ["Bureau of Fire Protection MPC", 68131.08],
        ["Nangalisan MPC", 63840.46]
      ]
      @title = "Top 10 in Small-scale Category"
      @color = "#25EE4F"
    elsif params[:data_type].to_i == 1
      @top = [
        ["Bohol Public School Teachers & Employees MPC", 1751859.72],
        ["National Teachers & Employees Cooperative Bank", 1479541.57],
        ["Ecosystem Research & Development Bureau MPC", 1177982.62],
        ["SCI Development MPC", 1122855.74],
        ["Balakilong Credit Cooperative", 941349.06],
        ["Isuzu Philippines Corporation Employees MPC", 881607.35],
        ["Aguinaldo Vets & Associates Credit Cooperative", 851702.03],
        ["Xavier University Community Credit Cooperative", 764263.47],
        ["Capiz Provincial MPC", 678757.25],
        ["Maco Development Cooperative", 663019.73]
      ]
      @title = "Top 10 in Medium-scale Category"
      @color = "#25EEEB"
    else
      @top = [
        ["Treasure Link Cooperative Society", 2680643.32],
        ["Ilocos Consolidated Cooperative Bank", 2273017.87],
        ["Abra Diocesan Teachers & Employees MPC", 2002185.54],
        ["San Jose MPC", 1527350.42],
        ["San Dionisio Credit Cooperative", 997098.68],
        ["Barangka Credit Cooperative", 962168.61],
        ["USPD Savings & Credit Cooperative", 926260.1],
        ["Sacred Heart Savings Cooperative", 900617.55],
        ["Samal Island MPC", 883225.20],
        ["San Jose Del Monte Savings & Credit Cooperative", 879582.32]
      ]
      @title = "Top 10 in Large-scale Category"
      @color = "#D80D0D"
    end



    respond_to do |format|
      format.turbo_stream
    end
    
  end
  
  def select_charts
    if params[:data_type].to_i == 0
      @select_chart = [
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
      @title = "Premium per Month"
    elsif params[:data_type].to_i == 1
      @select_chart = [
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
      @title = "Claims per Month"
    else
      @select_chart = [
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
       @title = "Premium vs. Claims per month"
    end
  
    respond_to do |format|
      format.turbo_stream
    end

    

  end

  def update_prem_annum
    @prem_per_year = case params[:data_type].to_i
    when 0 # 2020
      [{
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
          ["January", 20000000 * 0.20],
          ["February",10040000 * 0.39],
          ["March",30000200 * 0.12],
          ["April",35000000 * 0.33],
          ["May",60000000 * 0.19],
          ["June",20400100 * 0.41],
          ["July",40120398 * 0.62],
          ["August",50002010 * 0.24],
          ["September",28172881 * 0.15],
          ["October",30560000 * 0.22],
          ["November",20102491 * 0.18],
          ["December",40123800 * 0.26]
        ]
      }]

    when 1 # 2021
      [{
        name: "Premium",
        data: [
          ["January", 15000000],
          ["February",12012223],
          ["March",30000100],
          ["April",25001000],
          ["May",30000000],
          ["June",19000100],
          ["July",50120398],
          ["August",32902010],
          ["September",24002881],
          ["October",42160020],
          ["November",31202491],
          ["December",45123800]
        ]
      },
      {
        name: "Claims",
        data: [
          ["January", 15000000 * 0.20],
          ["February",12012223 * 0.39],
          ["March",30000100 * 0.12],
          ["April",25001000 * 0.33],
          ["May",30000000 * 0.19],
          ["June",19000100 * 0.41],
          ["July",50120398 * 0.62],
          ["August",32902010 * 0.24],
          ["September",28172881 * 0.15],
          ["October",42160020 * 0.22],
          ["November",31202491 * 0.18],
          ["December",61000020 * 0.56]
        ]
      }]

    when 2 # 2022
      [{
        name: "Premium",
        data: [
          ["January", 32100000],
          ["February",12940000],
          ["March",21000200],
          ["April",40000000],
          ["May",41100000],
          ["June",10200100],
          ["July",41200398],
          ["August",35002010],
          ["September",18972881],
          ["October",21060000],
          ["November",28002491],
          ["December",39023800]
        ]
      },
    {
      name: "Claims",
        data: [
          ["January", 32100000 * 0.23],
          ["February",12940000 * 0.21],
          ["March",21000200 * 0.36],
          ["April",40000000 * 0.24],
          ["May",41100000 * 0.28],
          ["June",10200100 * 0.31],
          ["July",41200398 * 0.33],
          ["August",35002010 * 0.25],
          ["September",18972881 * 0.29],
          ["October",21060000 * 0.30],
          ["November",28002491 * 0.31],
          ["December",39023800 * 0.40]
        ]
    }]
    when 3 # 2023
      [{
        name: "Premium",
        data: [
          ["January", 30000000],
          ["February",21040000],
          ["March",40000200],
          ["April",30000000],
          ["May",51000000],
          ["June",31000100],
          ["July",33020398],
          ["August",41002010],
          ["September",30072881],
          ["October",29060000]
        ]
      },
    {
      name: "Claims",
      data: [
        ["January", 30000000 * 0.31],
        ["February",21040000 * 0.32],
        ["March",40000200 * 0.33],
        ["April",30000000 * 0.34],
        ["May",51000000 * 0.35],
        ["June",31000100 * 0.29],
        ["July",33020398 * 0.28],
        ["August",41002010 * 0.42],
        ["September",30072881 * 0.27],
        ["October",29060000 * 1.2]
      ]
    }]
    end

    respond_to do |format|
      format.turbo_stream
    end

  end

  private

  def set_gender_chart
    min_value = 1_000_000  # 1 million
    max_value = 2_000_000  # 2 million
    step = 100_000

    random_number1 = min_value + (step * rand(((max_value - min_value) / step) + 1))
    random_number2 = min_value + (step * rand(((max_value - min_value) / step) + 1))
    
    @pie_chart_gender = [
      ["Male", random_number1],
      ["Female", random_number2]
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

    @premium_per_plan = [
      ["LPPI", 575331381.13],
      ["GYRT", 160646128.98],
      ["BLISS", 16951508.32],
      ["ICARD", 1282713],
      ["KOOPAMILYA", 59841676.66],
      ["SII", 69638935.22],
      ["SIP", 826656.56]
    ]

    @claims_per_plan = [
      [@premium_per_plan[0][0], @premium_per_plan[0][1] * 0.6],
      [@premium_per_plan[1][0], @premium_per_plan[1][1] * 0.2],
      [@premium_per_plan[2][0], @premium_per_plan[2][1] * 0.3],
      [@premium_per_plan[3][0], @premium_per_plan[3][1] * 0.4],
      [@premium_per_plan[4][0], @premium_per_plan[4][1] * 0.5],
      [@premium_per_plan[5][0], @premium_per_plan[5][1] * 0.6],
      [@premium_per_plan[6][0], @premium_per_plan[6][1] * 0.7]
      
    ]

    @prem_claim_agent = [
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

  end
  
  
end
