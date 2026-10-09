require "import"
import "android.widget.*"
import "android.view.*"
import "android.app.*"
import "android.content.*"
import "android.net.Uri"
import "android.media.MediaPlayer"
import "android.media.AudioManager"
import "android.os.Handler"
import "android.os.Looper"
import "java.util.ArrayList"
import "java.util.HashMap"

local Sys = luajava.bindClass("java.lang.System")
local PBC = "https://whmsonic.radio.gov.pk:"
local RG = "https://radio.garden/api/ara/content/listen/"
local UA = "Mozilla/5.0 (Linux; Android 12; Mobile) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36"

local defaultPakChannels = {
{name = "Saut-ul-Quran", url = PBC .. "7002/stream?type=http&nocache=12"},
{name = "FM 101 Islamabad", url = PBC .. "7008/stream?type=http&nocache=12"},
{name = "Planet FM 87.6", url = PBC .. "7042/stream?type=http&nocache=12"},
{name = "Islamabad Station", url = PBC .. "7003/stream?type=http&nocache=12"},
{name = "NCAC", url = PBC .. "7004/stream?type=http&nocache=12"},
{name = "World Service", url = PBC .. "7005/stream?type=http&nocache=12"},
{name = "External Service", url = PBC .. "7006/stream?type=http&nocache=12"},
{name = "Sports and Health Channel", url = PBC .. "7007/stream?type=http&nocache=12"},
{name = "Technology Channel", url = PBC .. "8094/stream?type=http&nocache=12"},
{name = "Environment", url = PBC .. "8102/stream?type=http&nocache=12"},
{name = "Health", url = PBC .. "7000/Health"},
{name = "Kids", url = PBC .. "7000/Kids"},
{name = "FM 101 Lahore", url = PBC .. "7000/101lahore"},
{name = "FM 93 Lahore", url = PBC .. "8088/stream?type=http&nocache=4"},
{name = "Lahore MW", url = PBC .. "8026/relay?type=http&nocache=9"},
{name = "FM 101 Bahawalpur", url = PBC .. "8020/relay?type=http&nocache=9"},
{name = "MW Bahawalpur", url = PBC .. "8092/relay?type=http&nocache=9"},
{name = "FM 93 Faisalabad", url = PBC .. "8022/relay?type=http&nocache=9"},
{name = "FM 101 Faisalabad", url = PBC .. "8024/relay?type=http&nocache=9"},
{name = "FM 93 Mianwali", url = PBC .. "8028/relay?type=http&nocache=9"},
{name = "FM 93 Multan", url = PBC .. "7014/stream?type=http&nocache=12"},
{name = "FM 101 Multan", url = PBC .. "8032/stream?type=http&nocache=12"},
{name = "Multan MW", url = PBC .. "8034/stream?type=http&nocache=12"},
{name = "FM 93 Rawalpindi", url = PBC .. "8036/relay?type=http&nocache=9"},
{name = "FM 101 Sialkot", url = PBC .. "8038/relay?type=http&nocache=9"},
{name = "FM 101 Sargodha", url = PBC .. "8040/relay?type=http&nocache=9"},
{name = "FM 101 Karachi", url = PBC .. "8048/stream?type=http&nocache=12"},
{name = "FM 93 Karachi", url = PBC .. "7022/stream?type=http&nocache=12"},
{name = "MW 639 Karachi", url = PBC .. "7000/MW639khi?type=http&nocache=9"},
{name = "FM 101 Hyderabad", url = PBC .. "8044/stream?type=http&nocache=12"},
{name = "Hyderabad MW 1008", url = PBC .. "8042/stream?type=http&nocache=12"},
{name = "FM 101 Larkana", url = PBC .. "8050/stream?type=http&nocache=12"},
{name = "FM 101 Mithi", url = PBC .. "8052/stream?type=http&nocache=12"},
{name = "FM 101 Khairpur", url = PBC .. "8054/stream?type=http&nocache=12"},
{name = "FM 101.4 Bhitshah", url = PBC .. "8098/stream?type=http&nocache=12"},
{name = "FM 101 Quetta", url = PBC .. "8058/stream?type=http&nocache=12"},
{name = "Quetta MW", url = PBC .. "8060/relay?type=http&nocache=9"},
{name = "Khuzdar MW 567", url = PBC .. "8062/stream?type=http&nocache=12"},
{name = "FM 101 Peshawar", url = PBC .. "8070/relay?type=http&nocache=9"},
{name = "Peshawar MW", url = PBC .. "8072/relay?type=http&nocache=9"},
{name = "FM 101 Kohat", url = PBC .. "8068/relay?type=http&nocache=9"},
{name = "FM 101 Abbottabad", url = PBC .. "8064/relay?type=http&nocache=9"},
{name = "FM 93 Chitral", url = PBC .. "8066/relay?type=http&nocache=9"},
{name = "D.I. Khan MW 711", url = PBC .. "7000/Dikhan?type=http&nocache=9"},
{name = "FM 101 Mirpur", url = PBC .. "8078/relay?type=http&nocache=9"},
{name = "AK Radio Tarakhel", url = PBC .. "8076/relay?type=http&nocache=9"},
{name = "FM 93 Muzaffarabad", url = PBC .. "7000/93muzaffarabad?type=http&nocache=9"},
{name = "Azad Kashmir Radio Mirpur", url = PBC .. "8074?type=http&nocache=9"},
{name = "FM 93 Gilgit", url = PBC .. "8090/relay?type=http&nocache=9"},
{name = "Gilgit MW 1512", url = PBC .. "8082/relay?type=http&nocache=9"},
{name = "FM 93 Skardu", url = PBC .. "8104/relay?type=http&nocache=9"},
{name = "MW 1557 Skardu", url = PBC .. "8080/relay?type=http&nocache=9"},
{name = "Suno FM 89.4", url = "https://streams.radio.co/s3f0e8e1a5/listen"},
{name = "Just Music FM 106.2", url = "https://streams.radio.co/s5c5c1c5c5/listen"},
}

local countryNames = {
"Pakistan","Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda",
"Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh",
"Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina",
"Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon",
"Canada","Cape Verde","Central African Republic","Chad","Chile","China","Colombia","Comoros",
"Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica",
"Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia",
"Eswatini","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana",
"Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary",
"Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Ivory Coast","Jamaica",
"Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon",
"Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Madagascar","Malawi",
"Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico",
"Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar",
"Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea",
"North Macedonia","Norway","Oman","Palau","Palestine","Panama","Papua New Guinea","Paraguay",
"Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Kitts and Nevis",
"Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe",
"Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia",
"Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan",
"Suriname","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor-Leste",
"Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine",
"United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vanuatu",
"Vatican City","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"
}

local countryCodes = {
["Pakistan"]="PK,PAK",["Afghanistan"]="AF,AFG",["Albania"]="AL,ALB",["Algeria"]="DZ,DZA",
["Andorra"]="AD,AND",["Angola"]="AO,AGO",["Antigua and Barbuda"]="AG,ATG",["Argentina"]="AR,ARG",
["Armenia"]="AM,ARM",["Australia"]="AU,AUS",["Austria"]="AT,AUT",["Azerbaijan"]="AZ,AZE",
["Bahamas"]="BS,BHS",["Bahrain"]="BH,BHR",["Bangladesh"]="BD,BGD",["Barbados"]="BB,BRB",
["Belarus"]="BY,BLR",["Belgium"]="BE,BEL",["Belize"]="BZ,BLZ",["Benin"]="BJ,BEN",["Bhutan"]="BT,BTN",
["Bolivia"]="BO,BOL",["Bosnia and Herzegovina"]="BA,BIH",["Botswana"]="BW,BWA",["Brazil"]="BR,BRA",
["Brunei"]="BN,BRN",["Bulgaria"]="BG,BGR",["Burkina Faso"]="BF,BFA",["Burundi"]="BI,BDI",
["Cambodia"]="KH,KHM",["Cameroon"]="CM,CMR",["Canada"]="CA,CAN",["Cape Verde"]="CV,CPV",
["Central African Republic"]="CF,CAF",["Chad"]="TD,TCD",["Chile"]="CL,CHL",["China"]="CN,CHN",
["Colombia"]="CO,COL",["Comoros"]="KM,COM",["Congo"]="CG,COG",["Costa Rica"]="CR,CRI",
["Croatia"]="HR,HRV",["Cuba"]="CU,CUB",["Cyprus"]="CY,CYP",["Czech Republic"]="CZ,CZE",
["Denmark"]="DK,DNK",["Djibouti"]="DJ,DJI",["Dominica"]="DM,DMA",["Dominican Republic"]="DO,DOM",
["Ecuador"]="EC,ECU",["Egypt"]="EG,EGY",["El Salvador"]="SV,SLV",["Equatorial Guinea"]="GQ,GNQ",
["Eritrea"]="ER,ERI",["Estonia"]="EE,EST",["Eswatini"]="SZ,SWZ",["Ethiopia"]="ET,ETH",
["Fiji"]="FJ,FJI",["Finland"]="FI,FIN",["France"]="FR,FRA",["Gabon"]="GA,GAB",["Gambia"]="GM,GMB",
["Georgia"]="GE,GEO",["Germany"]="DE,DEU",["Ghana"]="GH,GHA",["Greece"]="GR,GRC",["Grenada"]="GD,GRD",
["Guatemala"]="GT,GTM",["Guinea"]="GN,GIN",["Guinea-Bissau"]="GW,GNB",["Guyana"]="GY,GUY",
["Haiti"]="HT,HTI",["Honduras"]="HN,HND",["Hungary"]="HU,HUN",["Iceland"]="IS,ISL",["India"]="IN,IND",
["Indonesia"]="ID,IDN",["Iran"]="IR,IRN",["Iraq"]="IQ,IRQ",["Ireland"]="IE,IRL",["Israel"]="IL,ISR",
["Italy"]="IT,ITA",["Ivory Coast"]="CI,CIV",["Jamaica"]="JM,JAM",["Japan"]="JP,JPN",["Jordan"]="JO,JOR",
["Kazakhstan"]="KZ,KAZ",["Kenya"]="KE,KEN",["Kiribati"]="KI,KIR",["Kuwait"]="KW,KWT",
["Kyrgyzstan"]="KG,KGZ",["Laos"]="LA,LAO",["Latvia"]="LV,LVA",["Lebanon"]="LB,LBN",
["Lesotho"]="LS,LSO",["Liberia"]="LR,LBR",["Libya"]="LY,LBY",["Liechtenstein"]="LI,LIE",
["Lithuania"]="LT,LTU",["Luxembourg"]="LU,LUX",["Madagascar"]="MG,MDG",["Malawi"]="MW,MWI",
["Malaysia"]="MY,MYS",["Maldives"]="MV,MDV",["Mali"]="ML,MLI",["Malta"]="MT,MLT",
["Marshall Islands"]="MH,MHL",["Mauritania"]="MR,MRT",["Mauritius"]="MU,MUS",["Mexico"]="MX,MEX",
["Micronesia"]="FM,FSM",["Moldova"]="MD,MDA",["Monaco"]="MC,MCO",["Mongolia"]="MN,MNG",
["Montenegro"]="ME,MNE",["Morocco"]="MA,MAR",["Mozambique"]="MZ,MOZ",["Myanmar"]="MM,MMR",
["Namibia"]="NA,NAM",["Nauru"]="NR,NRU",["Nepal"]="NP,NPL",["Netherlands"]="NL,NLD",
["New Zealand"]="NZ,NZL",["Nicaragua"]="NI,NIC",["Niger"]="NE,NER",["Nigeria"]="NG,NGA",
["North Korea"]="KP,PRK",["North Macedonia"]="MK,MKD",["Norway"]="NO,NOR",["Oman"]="OM,OMN",
["Palau"]="PW,PLW",["Palestine"]="PS,PSE",["Panama"]="PA,PAN",["Papua New Guinea"]="PG,PNG",
["Paraguay"]="PY,PRY",["Peru"]="PE,PER",["Philippines"]="PH,PHL",["Poland"]="PL,POL",
["Portugal"]="PT,PRT",["Qatar"]="QA,QAT",["Romania"]="RO,ROU",["Russia"]="RU,RUS",["Rwanda"]="RW,RWA",
["Saint Kitts and Nevis"]="KN,KNA",["Saint Lucia"]="LC,LCA",["Saint Vincent and the Grenadines"]="VC,VCT",
["Samoa"]="WS,WSM",["San Marino"]="SM,SMR",["Sao Tome and Principe"]="ST,STP",["Saudi Arabia"]="SA,SAU",
["Senegal"]="SN,SEN",["Serbia"]="RS,SRB",["Seychelles"]="SC,SYC",["Sierra Leone"]="SL,SLE",
["Singapore"]="SG,SGP",["Slovakia"]="SK,SVK",["Slovenia"]="SI,SVN",["Solomon Islands"]="SB,SLB",
["Somalia"]="SO,SOM",["South Africa"]="ZA,ZAF",["South Korea"]="KR,KOR",["South Sudan"]="SS,SSD",
["Spain"]="ES,ESP",["Sri Lanka"]="LK,LKA",["Sudan"]="SD,SDN",["Suriname"]="SR,SUR",["Sweden"]="SE,SWE",
["Switzerland"]="CH,CHE",["Syria"]="SY,SYR",["Taiwan"]="TW,TWN",["Tajikistan"]="TJ,TJK",
["Tanzania"]="TZ,TZA",["Thailand"]="TH,THA",["Timor-Leste"]="TL,TLS",["Togo"]="TG,TGO",
["Tonga"]="TO,TON",["Trinidad and Tobago"]="TT,TTO",["Tunisia"]="TN,TUN",["Turkey"]="TR,TUR",
["Turkmenistan"]="TM,TKM",["Tuvalu"]="TV,TUV",["Uganda"]="UG,UGA",["Ukraine"]="UA,UKR",
["United Arab Emirates"]="AE,ARE",["United Kingdom"]="GB,GBR",["United States"]="US,USA",
["Uruguay"]="UY,URY",["Uzbekistan"]="UZ,UZB",["Vanuatu"]="VU,VUT",["Vatican City"]="VA,VAT",
["Venezuela"]="VE,VEN",["Vietnam"]="VN,VNM",["Yemen"]="YE,YEM",["Zambia"]="ZM,ZMB",["Zimbabwe"]="ZW,ZWE"
}

local languageAliases = {
["urdu"]="urdu",["اردو"]="urdu",["english"]="english",["انگلش"]="english",["انگریزی"]="english",
["arabic"]="arabic",["عربی"]="arabic",["punjabi"]="punjabi",["پنجابی"]="punjabi",["hindi"]="hindi",
["ہندی"]="hindi",["bengali"]="bengali",["bangla"]="bengali",["بنگالی"]="bengali",["pashto"]="pashto",
["پشتو"]="pashto",["persian"]="persian",["farsi"]="persian",["فارسی"]="persian",["turkish"]="turkish",
["ترکی"]="turkish",["french"]="french",["فرانسیسی"]="french",["spanish"]="spanish",["ہسپانوی"]="spanish",
["german"]="german",["جرمن"]="german",["italian"]="italian",["اطالوی"]="italian",
["portuguese"]="portuguese",["russian"]="russian",["روسی"]="russian",["chinese"]="chinese",
["چینی"]="chinese",["japanese"]="japanese",["جاپانی"]="japanese",["korean"]="korean",
["کورین"]="korean",["malayalam"]="malayalam",["tamil"]="tamil",["تامل"]="tamil",["telugu"]="telugu",
["marathi"]="marathi",["gujarati"]="gujarati",["nepali"]="nepali",["sindhi"]="sindhi",
["سندھی"]="sindhi",["balochi"]="balochi",["بلوچی"]="balochi",["saraiki"]="saraiki",["سرائیکی"]="saraiki"
}

-- ===== Update settings =====
-- CURRENT_VERSION is the version shown in About. It is changed automatically
-- when an update is installed (it is set to the number found in version.txt).
CURRENT_VERSION = "1.3"
UPDATER = {
  -- Raw GitHub links (the raw form of the blob links, so the real file is downloaded).
  versionUrl = "https://raw.githubusercontent.com/nabeelhafiz229-afk/World-radio.-/main/version.txt",
  codeUrl = "https://raw.githubusercontent.com/nabeelhafiz229-afk/World-radio.-/main/main.lua",
  path = "/storage/emulated/0/解说/Plugins/World Radio/main.lua",
  busy = false,
}
local DEVELOPER_NAME = "Prince Nabeel"
local WHATSAPP_NUMBER = "03234375740"
local WHATSAPP_INTL = "923234375740"

local ctx = activity or service or this
local currentCat = nil
local currentIdx = 1
local currentBack = nil
local currentDialog = nil
local favCat = {name = "Favourite", channels = {}}
local refreshCurrent = nil
local addTargetCat = nil
local searchBackFn = nil

local goodType = nil

local function toast(msg)
  pcall(function()
    Toast.makeText(ctx, tostring(msg), Toast.LENGTH_SHORT).show()
  end)
end

local function proxy(iface, tbl)
  return luajava.createProxy(iface, tbl)
end

local function post(fn, delay)
  local h = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
  h.postDelayed(proxy("java.lang.Runnable", {
    run = function() pcall(fn) end
  }), delay or 0)
end

local function guard(fn)
  return function(...)
    local args = {...}
    local ok, err = pcall(function() fn(table.unpack(args)) end)
    if not ok then toast("Error: " .. tostring(err)) end
  end
end

local function safeShow(dlg)
  local types
  if goodType ~= nil then
    types = {goodType}
  elseif service ~= nil and ctx == service then
    types = {2032, 0, 2038}
  else
    types = {0, 2032, 2038}
  end
  local lastErr = nil
  for _, t in ipairs(types) do
    local ok, err = pcall(function()
      if t ~= 0 then dlg.getWindow().setType(t) end
      dlg.show()
    end)
    if ok then
      goodType = t
      return true
    end
    lastErr = err
  end
  toast("Cannot show window: " .. tostring(lastErr))
  return false
end

local settings = nil
local stopPlayer = nil
local openDialogs = 0
local busyCount = 0

local myChannels = {}

local function loadMy()
  myChannels = {}
  pcall(function()
    local sp = ctx.getSharedPreferences("pkradio_prefs", 0)
    local s = tostring(sp.getString("mychannels", ""))
    for line in s:gmatch("[^\n]+") do
      local n, u = line:match("^(.-)\t(.+)$")
      if n and u then myChannels[#myChannels + 1] = {name = n, url = u} end
    end
  end)
end

local function saveMy()
  pcall(function()
    local lines = {}
    for _, c in ipairs(myChannels) do lines[#lines + 1] = c.name .. "\t" .. c.url end
    ctx.getSharedPreferences("pkradio_prefs", 0).edit()
      .putString("mychannels", table.concat(lines, "\n")).apply()
  end)
end

local function cleanText(s)
  s = tostring(s or "")
  s = s:gsub("[\t\r\n]", " ")
  s = s:gsub("^%s+", "")
  s = s:gsub("%s+$", "")
  return s
end

local function extractUrl(s)
  s = tostring(s or "")
  local u = s:match("https?://[^%s%]%)%[%(<>\"']+")
  if u then return u end
  u = s:match("%a[%w+.-]*://[^%s%]%)%[%(<>\"']+")
  if u then return u end
  local compact = s:gsub("%s+", "")
  if compact:find("%.") and not compact:find("^%a+://") and #compact > 3 then
    return "https://" .. compact
  end
  return nil
end

local function cooperate()
  local co, ismain = coroutine.running()
  if co ~= nil and ismain ~= true then
    pcall(coroutine.yield)
  end
end

-- Runs `work` in small slices on a background thread. The script engine only
-- lets one thread run Lua at a time, so a long job would freeze the screen
-- reader. Every slice ends at a cooperate() call and releases the engine.
local function coopRun(work, done)
  local co = coroutine.create(work)
  local ht = luajava.newInstance("android.os.HandlerThread", "pkradio-work")
  ht.start()
  local h = luajava.newInstance("android.os.Handler", ht.getLooper())
  local mainH = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
  local stepR
  stepR = proxy("java.lang.Runnable", {
    run = function()
      local okR, ok, res = pcall(coroutine.resume, co)
      if not okR then
        res = ok
        ok = false
      end
      if ok and coroutine.status(co) == "suspended" then
        h.postDelayed(stepR, 20)
        return
      end
      pcall(function() ht.quitSafely() end)
      mainH.post(proxy("java.lang.Runnable", {
        run = function()
          local okd, errd = pcall(done, ok, res)
          if not okd then toast("Error: " .. tostring(errd)) end
        end
      }))
    end
  })
  h.post(stepR)
end

local function readText(conn, limit)
  local ins = conn.getInputStream()
  local baos = luajava.newInstance("java.io.ByteArrayOutputStream")
  local buf = luajava.bindClass("java.nio.ByteBuffer").allocate(8192).array()
  local total, reads = 0, 0
  while total < limit do
    local n = ins.read(buf)
    if n < 0 then break end
    baos.write(buf, 0, n)
    total = total + n
    reads = reads + 1
    if reads % 24 == 0 then cooperate() end
  end
  pcall(function() ins.close() end)
  return tostring(baos.toString("UTF-8"))
end

local audioExts = {mp3 = 1, aac = 1, m4a = 1, ogg = 1, oga = 1, opus = 1, flac = 1, wav = 1, wma = 1, mp2 = 1}
local listExts = {m3u8 = 1, m3u = 1, pls = 1, asx = 1, xspf = 1}
local badExts = {png = 1, jpg = 1, jpeg = 1, gif = 1, svg = 1, webp = 1, ico = 1, css = 1, js = 1,
  woff = 1, woff2 = 1, ttf = 1, otf = 1, eot = 1, map = 1, mp4 = 1, webm = 1, pdf = 1, zip = 1,
  apk = 1, json = 1, xml = 1, txt = 1}
local badHosts = {"google", "facebook", "twitter", "youtube", "youtu.be", "instagram", "w3.org",
  "schema.org", "apple.com", "whatsapp", "tiktok", "doubleclick", "gstatic", "googleapis",
  "cloudflare", "jquery", "bootstrap", "fontawesome", "wordpress.org", "gravatar", "linkedin",
  "pinterest", "t.me", "telegram", "wa.me"}

local function hostBad(u)
  local host = u:lower():match("^https?://([^/]+)") or ""
  for _, b in ipairs(badHosts) do
    if host:find(b, 1, true) then return true end
  end
  return false
end

local function scoreUrl(u)
  local l = u:lower()
  local host = l:match("^https?://([^/]+)") or ""
  if hostBad(u) then return -1 end
  local path = (l:gsub("^https?://[^/]*", ""):gsub("[?#].*$", ""))
  local ext = path:match("%.(%w+)$")
  if ext and badExts[ext] then return -1 end
  local s = 0
  if ext and audioExts[ext] then s = s + 100 end
  if ext and listExts[ext] then s = s + 90 end
  if l:find("stream", 1, true) then s = s + 40 end
  for _, k in ipairs({"listen", "live", "radio", "icecast", "shoutcast", "audio", "player", "play"}) do
    if l:find(k, 1, true) then
      s = s + 12
      break
    end
  end
  if host:find(":%d%d%d%d") then s = s + 30 end
  if path == "" or path == "/" then s = s - 20 end
  return s
end

local function absUrl(base, u)
  u = tostring(u or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if u == "" then return nil end
  if u:match("^https?://") then return u end
  if u:match("^//") then return (base:match("^(https?:)") or "https:") .. u end
  if u:match("^%a[%w+.-]*:") then return nil end
  local ok, r = pcall(function()
    return luajava.newInstance("java.net.URL", luajava.newInstance("java.net.URL", base), u).toString()
  end)
  if ok and r then return tostring(r) end
  return nil
end

local function ciPat(e)
  return (e:gsub("%a", function(c) return "[" .. c:lower() .. c:upper() .. "]" end))
end

local function extractLinks(body, base)
  body = body:gsub("\\u0026", "&"):gsub("\\u002[Ff]", "/"):gsub("\\/", "/")
    :gsub("&amp;", "&"):gsub("&#038;", "&"):gsub("&#x2[Ff];", "/")
  local baseHost = base:lower():match("^https?://([^/]+)") or ""
  local cands, seen = {}, {}
  local function add(u, bonus)
    if not u or u == "" then return end
    u = u:gsub("[%.,]+$", "")
    local a = absUrl(base, u)
    if not a or seen[a] then return end
    local host = a:lower():match("^https?://([^/]+)") or ""
    local sc = scoreUrl(a) + (bonus or 0)
    local need = (host == baseHost) and 10 or 25
    if sc >= need then
      seen[a] = true
      cands[#cands + 1] = {url = a, score = sc, idx = #cands + 1}
    end
  end
  for u in body:gmatch("https?://[^%s\"'<>\\%(%){}%[%]|^`]+") do add(u, 0) end
  for _, e in ipairs({"mp3", "aac", "m3u8", "m3u", "pls", "ogg", "opus", "m4a", "asx", "xspf"}) do
    local ce = ciPat(e)
    for u in body:gmatch("[\"']([^\"'<>%s]+%." .. ce .. ")[\"']") do add(u, 60) end
    for u in body:gmatch("[\"']([^\"'<>%s]+%." .. ce .. "%?[^\"'<>%s]*)[\"']") do add(u, 60) end
  end
  for tag in body:gmatch("<[Aa][Uu][Dd][Ii][Oo][^>]*>") do
    add(tag:match("[Ss][Rr][Cc]%s*=%s*[\"']([^\"']+)"), 80)
  end
  for tag in body:gmatch("<[Ss][Oo][Uu][Rr][Cc][Ee][^>]*>") do
    add(tag:match("[Ss][Rr][Cc]%s*=%s*[\"']([^\"']+)"), 80)
  end
  table.sort(cands, function(x, y)
    if x.score ~= y.score then return x.score > y.score end
    return x.idx < y.idx
  end)
  local out = {}
  for i = 1, math.min(#cands, 10) do out[#out + 1] = cands[i].url end
  local nf = 0
  for tag in body:gmatch("<[Ii][Ff][Rr][Aa][Mm][Ee][^>]*>") do
    local u = tag:match("[Ss][Rr][Cc]%s*=%s*[\"']([^\"']+)")
    local a = u and absUrl(base, u)
    if a and not seen[a] and not hostBad(a) and nf < 3 then
      seen[a] = true
      nf = nf + 1
      out[#out + 1] = a
    end
  end
  return out
end

local function parsePlaylist(body, base)
  local out, seen = {}, {}
  local function add(u)
    local a = absUrl(base, u)
    if a and not seen[a] then
      seen[a] = true
      out[#out + 1] = a
    end
  end
  local isM3u = body:sub(1, 400):find("#EXTM3U", 1, true) ~= nil
  for line in body:gmatch("[^\r\n]+") do
    local l = line:gsub("^%s+", ""):gsub("%s+$", "")
    local pls = l:match("^[Ff]ile%d*=(.+)$")
    if pls then
      add(pls)
    elseif l:match("^https?://%S+$") then
      add(l)
    elseif isM3u and l ~= "" and l:sub(1, 1) ~= "#" and not l:find("%s") then
      add(l)
    end
  end
  for u in body:gmatch("[Hh][Rr][Ee][Ff]%s*=%s*[\"']([^\"']+)[\"']") do add(u) end
  for u in body:gmatch("<location>%s*([^<]-)%s*</location>") do add(u) end
  return out
end

local function openFollow(url)
  local cur = url
  for _ = 1, 8 do
    local conn = luajava.newInstance("java.net.URL", cur).openConnection()
    conn.setInstanceFollowRedirects(false)
    conn.setConnectTimeout(7000)
    conn.setReadTimeout(8000)
    conn.setRequestProperty("User-Agent", UA)
    conn.setRequestProperty("Accept", "*/*")
    local code = conn.getResponseCode()
    if code == 301 or code == 302 or code == 303 or code == 307 or code == 308 then
      local loc = conn.getHeaderField("Location")
      pcall(function() conn.disconnect() end)
      if not loc then return nil, "redirect without location" end
      cur = luajava.newInstance("java.net.URL", luajava.newInstance("java.net.URL", cur), loc).toString()
      cur = tostring(cur)
      cooperate()
    else
      return conn, code, cur
    end
  end
  return nil, "too many redirects"
end

-- Looks at one link and tells what it is: a live stream, a playlist or a web page.
local function inspectOne(url)
  local conn, code, final = openFollow(url)
  if not conn then return {kind = "error", err = code} end
  if code >= 400 then
    pcall(function() conn.disconnect() end)
    return {kind = "error", err = "HTTP " .. tostring(code)}
  end
  local ct = tostring(conn.getContentType() or ""):lower()
  local icy = conn.getHeaderField("icy-name") ~= nil or conn.getHeaderField("icy-metaint") ~= nil
  local path = (final:lower():gsub("[?#].*$", ""))
  local ext = path:match("%.(%w+)$")
  local isListCt = ct:find("mpegurl", 1, true) or ct:find("scpls", 1, true) or ct:find("pls", 1, true)
    or ct:find("xspf", 1, true) or ct:find("asx", 1, true) or ct:find("playlist", 1, true)
  local isListExt = ext and listExts[ext]
  local isTextCt = ct:find("text/", 1, true) or ct:find("html", 1, true) or ct:find("xml", 1, true)
    or ct:find("json", 1, true) or ct:find("javascript", 1, true)
  if icy or ct:find("ogg", 1, true) or (ct:find("^audio/") and not isListCt) then
    pcall(function() conn.disconnect() end)
    return {kind = "stream", url = final}
  end
  if isTextCt or isListCt or isListExt then
    local limit = (isListCt or isListExt) and 65536 or 300000
    local body = readText(conn, limit)
    pcall(function() conn.disconnect() end)
    if body:sub(1, 400):find("#EXTM3U", 1, true) and body:find("#EXT-X-", 1, true) then
      return {kind = "stream", url = final}
    end
    local lowBody = body:lower()
    local looksList = body:sub(1, 400):find("#EXTM3U", 1, true) or body:find("[playlist]", 1, true)
      or lowBody:find("<asx", 1, true) or lowBody:find("<location>", 1, true) or isListCt or isListExt
    if looksList then
      local urls = parsePlaylist(body, final)
      if #urls > 0 then return {kind = "playlist", urls = urls} end
    end
    return {kind = "web", urls = extractLinks(body, final), base = final}
  end
  pcall(function() conn.disconnect() end)
  return {kind = "stream", url = final}
end

-- Finds the real live stream for any link: redirects, playlists and web pages.
local function inspectUrl(url)
  local deadline = os.time() + 30
  local fetches = 0
  local result, fromWeb = nil, false
  local function walk(u, depth, viaWeb)
    if result or depth > 4 or fetches >= 16 or os.time() > deadline then return end
    fetches = fetches + 1
    local ok, r = pcall(inspectOne, u)
    cooperate()
    if not ok or type(r) ~= "table" then return end
    if r.kind == "stream" then
      result = r.url
      fromWeb = viaWeb
    elseif r.kind == "playlist" or r.kind == "web" then
      local lim = (r.kind == "web") and 8 or 5
      for i = 1, math.min(#r.urls, lim) do
        if result then break end
        walk(r.urls[i], depth + 1, viaWeb or r.kind == "web")
      end
      if not result and r.kind == "web" and depth == 1 then
        local origin = (r.base or u):match("^(https?://[^/]+)")
        if origin then
          for _, g in ipairs({"/stream", "/live", "/;"}) do
            if result then break end
            walk(origin .. g, 4, true)
          end
        end
      end
    end
  end
  walk(url, 1, false)
  if result then return {urls = {result}, fromWeb = fromWeb} end
  return {urls = {}, fromWeb = false}
end

local function resolveUrl(url)
  local ok, r = pcall(inspectUrl, url)
  if ok and type(r) == "table" and r.urls and r.urls[1] then return r.urls[1] end
  return url
end

local function probeUrl(url)
  local ok, res = pcall(function()
    local conn = luajava.newInstance("java.net.URL", url).openConnection()
    conn.setInstanceFollowRedirects(true)
    conn.setConnectTimeout(7000)
    conn.setReadTimeout(7000)
    conn.setRequestProperty("User-Agent", UA)
    local code = conn.getResponseCode()
    local ct = tostring(conn.getContentType() or "unknown")
    local icy = tostring(conn.getHeaderField("icy-name") or "")
    pcall(function() conn.disconnect() end)
    return "HTTP " .. tostring(code) .. ", type: " .. ct .. ((icy ~= "") and (", station: " .. icy) or "")
  end)
  if ok then return res end
  return "Could not connect: " .. tostring(res)
end

local function buildAttempts(url)
  local list, seen = {}, {}
  local function add(u, hdr)
    local k = u .. (hdr and "|h" or "|n")
    if not seen[k] then
      seen[k] = true
      list[#list + 1] = {url = u, hdr = hdr, timeout = 15000}
    end
  end
  add(url, true)
  add(url, false)
  list[#list + 1] = {resolve = true}
  if url:lower():find("^http://") then
    add("https://" .. url:sub(8), true)
  elseif url:lower():find("^https://") then
    add("http://" .. url:sub(9), true)
  end
  local host = url:match("^(https?://[^/]+)/?$")
  if host then
    add(host .. "/;", true)
    add(host .. "/;stream.mp3", true)
  end
  return list
end

local function clearAppCache()
  local count = 0
  pcall(function()
    local cdir = ctx.getCacheDir()
    if cdir ~= nil and cdir.exists() then
      local files = cdir.listFiles()
      if files ~= nil then
        for i = 0, files.length - 1 do
          pcall(function()
            if files[i].isDirectory() then
              local sub = files[i].listFiles()
              if sub ~= nil then
                for j = 0, sub.length - 1 do
                  pcall(function() sub[j].delete() end)
                end
              end
            end
            if files[i].delete() then count = count + 1 end
          end)
        end
      end
    end
  end)
  pcall(function() Sys.clearProperty("pkradio.places2") end)
  return count
end

local function scheduleExitCheck()
  pcall(function()
    local h = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
    h.postDelayed(proxy("java.lang.Runnable", {
      run = function()
        if openDialogs <= 0 and busyCount <= 0 and settings and not settings.background and stopPlayer then
          stopPlayer()
          pcall(clearAppCache)
        end
      end
    }), 700)
  end)
end

local function trackDialog(dlg)
  openDialogs = openDialogs + 1
  local counted = true
  pcall(function()
    dlg.setOnDismissListener(proxy("android.content.DialogInterface$OnDismissListener", {
      onDismiss = function(d)
        if counted then
          counted = false
          openDialogs = openDialogs - 1
          scheduleExitCheck()
        end
      end
    }))
  end)
end

local function showDialog(dlg)
  trackDialog(dlg)
  if safeShow(dlg) then
    currentDialog = dlg
  end
end

local function showOverlay(dlg)
  trackDialog(dlg)
  return safeShow(dlg)
end

local function closeDialog()
  pcall(function()
    if currentDialog then currentDialog.dismiss() end
  end)
  currentDialog = nil
end

local function showMessage(title, msg)
  local b = AlertDialog.Builder(ctx)
  b.setTitle(title)
  b.setMessage(msg)
  b.setPositiveButton("OK", nil)
  showOverlay(b.create())
end

local function prefGet(key, fallback)
  local v = fallback
  pcall(function()
    local sp = ctx.getSharedPreferences("pkradio_prefs", 0)
    local s = tostring(sp.getString(key, ""))
    if s ~= "" then v = s end
  end)
  return v
end

local function prefSet(key, value)
  pcall(function()
    local sp = ctx.getSharedPreferences("pkradio_prefs", 0)
    sp.edit().putString(key, tostring(value)).apply()
  end)
end

settings = {
  rb = prefGet("rb", "1") == "1",
  background = prefGet("bg", "1") == "1",
  home = prefGet("home", "auto"),
  countryCap = tonumber(prefGet("ccap", "80")) or 80,
  homeFirst = prefGet("homefirst", "1") == "1",
  tags = prefGet("tags", "1") == "1",
  useLocation = prefGet("useloc", "1") == "1",
}

local settingKeys = {
  rb = "rb",
  background = "bg",
  home = "home",
  countryCap = "ccap",
  homeFirst = "homefirst",
  tags = "tags",
  useLocation = "useloc",
}

local function setSetting(k, v)
  settings[k] = v
  local sv = v
  if type(v) == "boolean" then sv = v and "1" or "0" end
  prefSet(settingKeys[k], sv)
end

local function resetSettings()
  for _, key in pairs(settingKeys) do prefSet(key, "") end
  settings.rb = true
  settings.background = true
  settings.home = "auto"
  settings.countryCap = 80
  settings.homeFirst = true
  settings.tags = true
  settings.useLocation = true
end

_locState = _locState or {}

function isoToCountryName(iso)
  iso = tostring(iso or ""):upper()
  if iso == "" then return nil end
  for _, name in ipairs(countryNames) do
    local first = (countryCodes[name] or ""):match("^([^,]+)")
    if first == iso then return name end
  end
  return nil
end

local function deviceCountry()
  local st = _locState
  local now = os.time()
  if st.cached and st.cachedAt and (now - st.cachedAt) < 60 then
    return st.cached
  end
  local found = nil
  -- 1) real GPS / network location (resolved to a country)
  if settings.useLocation and st.fresh then found = st.fresh end
  -- 2) country of the mobile network the phone is on right now
  local netIso, simIso = "", ""
  pcall(function()
    local tm = ctx.getSystemService(Context.TELEPHONY_SERVICE)
    netIso = tostring(tm.getNetworkCountryIso() or "")
    simIso = tostring(tm.getSimCountryIso() or "")
  end)
  if not found then found = isoToCountryName(netIso) end
  -- 3) last country found from location (saved)
  if not found and settings.useLocation then
    if not st.loaded then
      st.loaded = true
      local sv = prefGet("lastloc", "")
      if sv ~= "" then st.saved = sv end
    end
    found = st.saved
  end
  -- 4) SIM country, 5) phone language region (last resort)
  if not found then found = isoToCountryName(simIso) end
  if not found then
    pcall(function()
      found = isoToCountryName(luajava.bindClass("java.util.Locale").getDefault().getCountry())
    end)
  end
  found = found or "Pakistan"
  st.cached, st.cachedAt = found, now
  return found
end

local function getHome()
  if settings.home == "auto" then return deviceCountry() end
  return settings.home
end

local function homeIso()
  return ((countryCodes[getHome()] or ""):match("^([^,]+)")) or ""
end

local function loadFavs()
  favCat.channels = {}
  pcall(function()
    local sp = ctx.getSharedPreferences("pkradio_prefs", 0)
    local s = tostring(sp.getString("favs", ""))
    for line in s:gmatch("[^\n]+") do
      local n, u = line:match("^(.-)\t(.+)$")
      if n and u then
        favCat.channels[#favCat.channels + 1] = {name = n, url = u}
      end
    end
  end)
end

local function saveFavs()
  pcall(function()
    local lines = {}
    for _, ch in ipairs(favCat.channels) do
      lines[#lines + 1] = ch.name .. "\t" .. ch.url
    end
    local sp = ctx.getSharedPreferences("pkradio_prefs", 0)
    sp.edit().putString("favs", table.concat(lines, "\n")).apply()
  end)
end

local function addFav(ch)
  if not ch then return end
  for _, f in ipairs(favCat.channels) do
    if f.url == ch.url then
      toast("Already in Favourite: " .. ch.name)
      return
    end
  end
  favCat.channels[#favCat.channels + 1] = {name = ch.name, url = ch.url}
  saveFavs()
  toast("Added to Favourite: " .. ch.name)
end

local function removeFav(ch)
  if not ch then return end
  for i, f in ipairs(favCat.channels) do
    if f.url == ch.url then
      table.remove(favCat.channels, i)
      saveFavs()
      toast("Removed from Favourite: " .. ch.name)
      return
    end
  end
end

loadFavs()

local pakRadioCat = {name = "Pakistan Radio", channels = {}, isUserList = true, isPakRadio = true}

local function savePakRadio()
  local lines = {}
  for _, ch in ipairs(pakRadioCat.channels) do
    lines[#lines + 1] = ch.name .. "\t" .. ch.url
  end
  prefSet("pakradio", table.concat(lines, "\n"))
end

local function loadPakRadio()
  pakRadioCat.channels = {}
  local s = prefGet("pakradio", "")
  if s == "" then
    for _, ch in ipairs(defaultPakChannels) do
      pakRadioCat.channels[#pakRadioCat.channels + 1] = {name = ch.name, url = ch.url}
    end
    savePakRadio()
  else
    for line in s:gmatch("[^\n]+") do
      local n, u = line:match("^(.-)\t(.+)$")
      if n and u then
        pakRadioCat.channels[#pakRadioCat.channels + 1] = {name = n, url = u}
      end
    end
  end
end

loadPakRadio()

local myCat = {name = "My Custom Channels", channels = {}, isUserList = true, isMyCat = true}

local function refreshMyCat()
  myCat.channels = {}
  for _, c in ipairs(myChannels) do
    myCat.channels[#myCat.channels + 1] = {name = c.name, url = c.url}
  end
end

loadMy()
refreshMyCat()

local userLists = {}

local function cleanName(s)
  s = tostring(s or "")
  s = s:gsub("[\t\r\n]", " ")
  s = s:gsub("^%s+", "")
  s = s:gsub("%s+$", "")
  return s
end

local function loadLists()
  userLists = {}
  local s = prefGet("lists", "")
  local cur = nil
  for line in s:gmatch("[^\n]+") do
    local tag, rest = line:match("^(%a)\t(.*)$")
    if tag == "L" then
      cur = {name = rest, channels = {}}
      userLists[#userLists + 1] = cur
    elseif tag == "C" and cur then
      local n, u = rest:match("^(.-)\t(.+)$")
      if n and u then cur.channels[#cur.channels + 1] = {name = n, url = u} end
    end
  end
end

local function saveLists()
  local lines = {}
  for _, l in ipairs(userLists) do
    lines[#lines + 1] = "L\t" .. l.name
    for _, ch in ipairs(l.channels) do
      lines[#lines + 1] = "C\t" .. cleanName(ch.name) .. "\t" .. ch.url
    end
  end
  prefSet("lists", table.concat(lines, "\n"))
end

local function createList(name)
  local l = {name = cleanName(name), channels = {}}
  userLists[#userLists + 1] = l
  saveLists()
  return l
end

local function addToList(list, ch)
  if not list or not ch then return end
  for _, f in ipairs(list.channels) do
    if f.url == ch.url then
      toast("Already in " .. list.name .. ": " .. ch.name)
      return
    end
  end
  list.channels[#list.channels + 1] = {name = ch.name, url = ch.url}
  if list == pakRadioCat then savePakRadio() else saveLists() end
  toast("Added to " .. list.name .. ": " .. ch.name)
end

local function renameList(list, name)
  list.name = cleanName(name)
  saveLists()
end

local function deleteList(i)
  table.remove(userLists, i)
  saveLists()
end

loadLists()

local httpGet = nil
local runAsync = nil
local KEY_PLAYER = "pkradio.player"
local KEY_TOKEN = "pkradio.token"
local KEY_READY = "pkradio.ready"
local KEY_SERIAL = "pkradio.serial"

local function getSerial()
  return tonumber(Sys.getProperty(KEY_SERIAL) or "0") or 0
end

local function bumpSerial()
  local s = getSerial() + 1
  Sys.setProperty(KEY_SERIAL, tostring(s))
  return s
end

local function playerActive()
  local ok, res = pcall(function()
    return Sys.getProperties().get(KEY_PLAYER) ~= nil
  end)
  return ok and res == true
end

local function releaseOnly()
  pcall(function()
    local props = Sys.getProperties()
    local old = props.get(KEY_PLAYER)
    props.remove(KEY_PLAYER)
    local wasReady = tostring(Sys.getProperty(KEY_READY)) == "1"
    Sys.setProperty(KEY_READY, "0")
    if old and wasReady then
      local t = luajava.newInstance("java.lang.Thread", proxy("java.lang.Runnable", {
        run = function()
          pcall(function() old.setOnErrorListener(nil) end)
          pcall(function() old.setOnCompletionListener(nil) end)
          pcall(function() old.release() end)
        end
      }))
      t.start()
    end
  end)
end

stopPlayer = function()
  Sys.setProperty(KEY_TOKEN, "stopped")
  bumpSerial()
  releaseOnly()
end

local showNowPlaying, showCategories, showChannels, askSearch, showLists, showSettings

local function errText(what, extra)
  local w = tonumber(what) or 0
  local e = tonumber(extra) or 0
  local wt = (w == 1 and "the player hit an unknown problem")
    or (w == 100 and "the Android media service crashed")
    or (w == 200 and "this stream cannot be played progressively")
    or "the player reported a problem"
  local et = ({
    [-1004] = "network or connection error while reading the stream",
    [-1007] = "the stream data is damaged or in a wrong format",
    [-1010] = "this audio format is not supported by the Android player",
    [-110] = "the connection timed out",
    [-2147483648] = "the Android audio system could not handle this stream (usually an unsupported audio format)",
  })[e] or "no more detail from the player"
  return wt .. " - " .. et
end

-- Turns the player error + server check into one plain sentence (no codes).
function explainFailure(lastErr, info, url)
  local inf = tostring(info or "")
  local infLow = inf:lower()
  local errLow = tostring(lastErr or ""):lower()
  local lowUrl = tostring(url or ""):lower()
  local code = tonumber(inf:match("^HTTP (%d+)"))
  local ct = (inf:match("type: ([^,]+)") or ""):lower()
  if inf:find("^Could not connect") then
    if infLow:find("unknownhost") or infLow:find("unable to resolve") or infLow:find("no address") then
      return "The server address was not found. Either your internet is off, or this channel's link is old and no longer exists."
    elseif infLow:find("timed out") or infLow:find("timeout") then
      return "The server did not answer in time. It may be down or very slow."
    elseif infLow:find("refused") then
      return "The server refused the connection. The station is probably offline."
    elseif infLow:find("ssl") or infLow:find("certificate") or infLow:find("trust") then
      return "The secure (https) connection failed because of a certificate problem on the server."
    elseif infLow:find("unreachable") or infLow:find("network") then
      return "The network is not reachable. Check your internet connection."
    end
    return "Could not connect to the server. " .. inf:gsub("^Could not connect: ", "")
  end
  if code and code >= 400 then
    if code == 401 or code == 403 then
      return "The server refused access to this stream (blocked or login needed)."
    elseif code == 404 or code == 410 then
      return "This stream link was not found. The channel was removed or its link has changed."
    elseif code >= 500 then
      return "The station's server has a problem right now. Try again later."
    end
    return "The server did not allow this request."
  end
  if ct:find("html") then
    return "This link opens a web page, not an audio stream."
  end
  if ct:find("x%-ms") or ct:find("asf") or ct:find("wma") or ct:find("asx")
     or lowUrl:find("c=wmp", 1, true) or lowUrl:find("%.wma") or lowUrl:find("%.asx") or lowUrl:find("mms://", 1, true) then
    return "This station streams in Windows Media (WMA) format, which the Android player cannot play."
  end
  if errLow:find("not supported by the android player") or errLow:find("unsupported audio format")
     or errLow:find("wrong format") then
    return "The server is working, but the audio format of this stream is not supported by the Android player."
  end
  if errLow:find("timed out") or errLow:find("no response") then
    return "The station did not start playing in time. It may be offline or very slow."
  end
  if code and code < 400 then
    return "The server answered, but the stream could not be decoded. The station may be offline or use an unsupported format."
  end
  return tostring(lastErr or "The station did not respond.")
end

local function failAll(ch, token, lastErr)
  if Sys.getProperty(KEY_TOKEN) ~= token then return end
  stopPlayer()
  toast("Channel not working: " .. ch.name)
  coopRun(function() return probeUrl(ch.url) end, function(ok, info)
    local hint = "\n\nTry:\n- Check the link in a browser.\n- Try https version.\n- Use direct stream link."
    showMessage("Could not play: " .. ch.name,
      "Reason: " .. explainFailure(lastErr, info, ch.url) ..
      "\n\nPlayer said: " .. tostring(lastErr or "no response") ..
      "\nLink: " .. ch.url .. hint)
  end)
end

local function nextAttempt(ch, attempts, i, token, lastErr)
  if Sys.getProperty(KEY_TOKEN) ~= token then return end
  if i > #attempts then
    failAll(ch, token, lastErr)
    return
  end
  local a = attempts[i]

  if a.resolve then
    local mySerial = bumpSerial()
    releaseOnly()
    toast("Looking for the real stream...")
    coopRun(function()
      local real = ch.url
      pcall(function() real = resolveUrl(ch.url) end)
      return real
    end, function(ok, real)
      if not ok or type(real) ~= "string" then real = ch.url end
      if mySerial ~= getSerial() or Sys.getProperty(KEY_TOKEN) ~= token then return end
      if real ~= ch.url then
        table.insert(attempts, i + 1, {url = real, hdr = false, timeout = 15000})
        table.insert(attempts, i + 1, {url = real, hdr = true, timeout = 15000})
      end
      nextAttempt(ch, attempts, i + 1, token, lastErr)
    end)
    return
  end

  local mySerial = bumpSerial()
  releaseOnly()
  if i > 1 then toast("Trying another method (" .. i .. ")") end

  local ok, err = pcall(function()
    local mp = MediaPlayer()
    Sys.setProperty(KEY_READY, "0")
    Sys.getProperties().put(KEY_PLAYER, mp)
    mp.setAudioStreamType(AudioManager.STREAM_MUSIC)
    pcall(function() mp.setWakeMode(ctx, 1) end)
    if a.hdr then
      local headers = luajava.newInstance("java.util.HashMap")
      headers.put("User-Agent", UA)
      headers.put("Accept", "*/*")
      mp.setDataSource(ctx, Uri.parse(a.url), headers)
    else
      mp.setDataSource(a.url)
    end
    mp.setOnPreparedListener(proxy("android.media.MediaPlayer$OnPreparedListener", {
      onPrepared = function(p)
        pcall(function()
          if mySerial == getSerial() and Sys.getProperty(KEY_TOKEN) == token then
            Sys.setProperty(KEY_READY, "1")
            attempts.playStart = os.time()
            p.start()
            toast("Playing: " .. ch.name)
          else
            pcall(function() p.release() end)
          end
        end)
      end
    }))
    mp.setOnErrorListener(proxy("android.media.MediaPlayer$OnErrorListener", {
      onError = function(p, what, extra)
        pcall(function()
          if mySerial == getSerial() and Sys.getProperty(KEY_TOKEN) == token then
            local msg = errText(what, extra)
            if tostring(Sys.getProperty(KEY_READY)) == "1" then
              if attempts.playStart and os.time() - attempts.playStart > 60 then
                attempts.reconnects = 0
              end
              attempts.reconnects = (attempts.reconnects or 0) + 1
              if attempts.reconnects <= 3 then
                toast("Reconnecting")
                post(function() nextAttempt(ch, attempts, i, token, msg) end, 1500)
              else
                post(function() failAll(ch, token, msg) end)
              end
            else
              post(function() nextAttempt(ch, attempts, i + 1, token, msg) end)
            end
          else
            pcall(function() p.release() end)
          end
        end)
        return true
      end
    }))
    mp.setOnCompletionListener(proxy("android.media.MediaPlayer$OnCompletionListener", {
      onCompletion = function(p)
        pcall(function()
          if mySerial == getSerial() and Sys.getProperty(KEY_TOKEN) == token then stopPlayer() end
        end)
      end
    }))
    mp.prepareAsync()
  end)

  if not ok then
    post(function() nextAttempt(ch, attempts, i + 1, token, tostring(err)) end)
    return
  end

  post(function()
    if mySerial == getSerial() and Sys.getProperty(KEY_TOKEN) == token
       and tostring(Sys.getProperty(KEY_READY)) ~= "1" then
      nextAttempt(ch, attempts, i + 1, token, "no response (timeout)")
    end
  end, a.timeout or 15000)
end

local resolvedCache = {}

local function attemptsFor(ch, urls, keepOriginal)
  local attempts = {}
  for idx, u in ipairs(urls) do
    if idx == 1 then
      for _, a in ipairs(buildAttempts(u)) do attempts[#attempts + 1] = a end
    elseif idx <= 3 then
      attempts[#attempts + 1] = {url = u, hdr = true, timeout = 15000}
    end
  end
  if keepOriginal and urls[1] ~= ch.url then
    for _, a in ipairs(buildAttempts(ch.url)) do attempts[#attempts + 1] = a end
  end
  return attempts
end

-- Any link works: stream, redirect, playlist or even a web page with a player.
local function startPlay(ch, token)
  local url = tostring(ch.url or "")
  local cached = resolvedCache[url]
  if cached then
    nextAttempt(ch, attemptsFor(ch, cached, false), 1, token, nil)
    return
  end
  local low = url:lower()
  if not low:find("^https?://") or low:find("radio.gov.pk", 1, true) then
    nextAttempt(ch, buildAttempts(url), 1, token, nil)
    return
  end
  coopRun(function() return inspectUrl(url) end, function(ok, res)
    if Sys.getProperty(KEY_TOKEN) ~= token then return end
    local attempts
    if ok and type(res) == "table" and res.urls and #res.urls > 0 then
      if res.fromWeb then
        resolvedCache[url] = res.urls
        toast("Live stream found in the website")
      end
      attempts = attemptsFor(ch, res.urls, not res.fromWeb)
    else
      attempts = buildAttempts(url)
    end
    nextAttempt(ch, attempts, 1, token, nil)
  end)
end

local function playCustomChannel(ch)
  if not ch then return end
  stopPlayer()
  local token = tostring(os.time()) .. "-" .. tostring(math.random(1, 999999))
  Sys.setProperty(KEY_TOKEN, token)
  toast("Loading: " .. ch.name)
  startPlay(ch, token)
end

local function playChannel(cat, idx)
  local ch = cat and cat.channels[idx]
  if not ch then return end
  stopPlayer()
  currentCat, currentIdx = cat, idx
  local token = tostring(os.time()) .. "-" .. tostring(math.random(1, 999999))
  Sys.setProperty(KEY_TOKEN, token)
  toast("Loading: " .. ch.name)
  startPlay(ch, token)
end

local function changeVolume(dir)
  pcall(function()
    local am = ctx.getSystemService(Context.AUDIO_SERVICE)
    am.adjustStreamVolume(AudioManager.STREAM_MUSIC, dir, AudioManager.FLAG_SHOW_UI)
  end)
end

local function step(delta)
  if not currentCat then return end
  local n = #currentCat.channels
  if n == 0 then return end
  local idx = currentIdx + delta
  if idx > n then idx = 1 end
  if idx < 1 then idx = n end
  playChannel(currentCat, idx)
end

local URLEncoder = luajava.bindClass("java.net.URLEncoder")

httpGet = function(urlStr)
  local u = luajava.newInstance("java.net.URL", urlStr)
  local conn = u.openConnection()
  conn.setConnectTimeout(8000)
  conn.setReadTimeout(15000)
  conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36")
  conn.setRequestProperty("Accept", "application/json")
  conn.setRequestProperty("Referer", "https://radio.garden/")
  local text = readText(conn, 16000000)
  pcall(function() conn.disconnect() end)
  cooperate()
  return text
end

local function unescapeJson(str)
  str = str:gsub("\\u(%x%x%x%x)", function(h)
    local cp = tonumber(h, 16)
    if cp < 0x80 then return string.char(cp)
    elseif cp < 0x800 then return string.char(0xC0 + math.floor(cp/64), 0x80 + cp%64)
    else return string.char(0xE0 + math.floor(cp/4096), 0x80 + math.floor(cp/64)%64, 0x80 + cp%64) end
  end)
  str = str:gsub("\\/", "/")
  str = str:gsub('\\"', '"')
  str = str:gsub("\\\\", "\\")
  return str
end

local function parseHits(body)
  local found, places, starts = {}, {}, {}
  local pos = 1
  while true do
    local a = body:find('"_source"', pos, true)
    if not a then break end
    starts[#starts + 1] = a
    pos = a + 9
  end
  for i, a in ipairs(starts) do
    local e = (starts[i+1] or (#body+1)) - 1
    local chunk = body:sub(a, e)
    local url = unescapeJson(chunk:match('"url"%s*:%s*"([^"]*)"') or "")
    local title = unescapeJson(chunk:match('"title"%s*:%s*"([^"]*)"') or "")
    local sub = unescapeJson(chunk:match('"subtitle"%s*:%s*"([^"]*)"') or "")
    local code = chunk:match('"code"%s*:%s*"([^"]*)"') or ""
    local typ = chunk:match('"type"%s*:%s*"([^"]*)"') or ""
    local sid = url:match("/listen/[^/]+/([^/]+)$")
    if url:find("/listen/", 1, true) and sid then
      found[#found + 1] = {id = sid, title = title, sub = sub, code = code}
    else
      local pid = url:match("/visit/[^/]+/([^/]+)$")
      if pid and typ == "place" then
        places[#places + 1] = {id = pid, title = title, sub = sub, code = code}
      end
    end
  end
  return found, #starts, places
end

local function searchRadioGarden(q)
  local body = tostring(httpGet("https://radio.garden/api/search?q=" .. tostring(URLEncoder.encode(q, "UTF-8"))))
  local found, raw, places = parseHits(body)
  return found, raw, body:sub(1, 120), places
end

local function enclosingObject(body, a)
  local depth = 0
  local st = a
  while st > 1 do
    local c = body:sub(st, st)
    if c == "}" then depth = depth + 1
    elseif c == "{" then
      if depth == 0 then break end
      depth = depth - 1
    end
    st = st - 1
  end
  local s1, e1 = body:find("%b{}", st)
  if not s1 then return "" end
  return body:sub(s1, e1)
end

local function topField(obj, key)
  local inner = obj:sub(2, -2)
  inner = inner:gsub("%b{}", "")
  inner = inner:gsub("%b[]", "")
  return inner:match('"' .. key .. '"%s*:%s*"([^"]*)"') or ""
end

local function channelInfo(id)
  local ok, body = pcall(httpGet, "https://radio.garden/api/ara/content/channel/" .. id)
  if not ok then return nil end
  body = tostring(body)
  local data = body:match('"data"%s*:%s*(%b{})')
  if not data then return nil end
  local placeObj = data:match('"place"%s*:%s*(%b{})') or "{}"
  local countryObj = data:match('"country"%s*:%s*(%b{})') or "{}"
  return {
    title = unescapeJson(topField(data, "title")),
    place = unescapeJson(topField(placeObj, "title")),
    country = unescapeJson(topField(countryObj, "title")),
  }
end

local PLACES_KEY = "pkradio.places2"

local function getAllPlaces()
  local cached = Sys.getProperty(PLACES_KEY)
  local text
  if cached ~= nil then
    text = tostring(cached)
  else
    local body = tostring(httpGet("https://radio.garden/api/ara/content/places"))
    local lines = {}
    local listStart = body:find('"list"%s*:%s*%[') or 1
    body = body:sub(listStart)
    local nObj = 0
    for obj in body:gmatch("%b{}") do
      nObj = nObj + 1
      if nObj % 150 == 0 then cooperate() end
      local id = obj:match('"id"%s*:%s*"([^"]*)"')
      local title = obj:match('"title"%s*:%s*"([^"]*)"')
      local country = obj:match('"country"%s*:%s*"([^"]*)"')
      local size = obj:match('"size"%s*:%s*(%d+)') or "0"
      if id and title and country then
        lines[#lines + 1] = id .. "\t" .. unescapeJson(title) .. "\t" .. unescapeJson(country) .. "\t" .. size
      end
    end
    text = table.concat(lines, "\n")
    if #lines > 0 then Sys.setProperty(PLACES_KEY, text) end
  end
  local out = {}
  local nLine = 0
  for line in text:gmatch("[^\n]+") do
    nLine = nLine + 1
    if nLine % 300 == 0 then cooperate() end
    local id, title, country, size = line:match("^(.-)\t(.-)\t(.-)\t(%d+)$")
    if id then out[#out + 1] = {id = id, title = title, sub = country, size = tonumber(size) or 0} end
  end
  return out
end

local RB_HOSTS = {
  "https://de1.api.radio-browser.info",
  "https://de2.api.radio-browser.info",
  "https://fi1.api.radio-browser.info",
  "https://all.api.radio-browser.info",
}

local rbHost = 1

local function urlEnc(s)
  local e = tostring(URLEncoder.encode(tostring(s), "UTF-8"))
  e = e:gsub("%+", "%%20")
  return e
end

local function rbGet(path)
  local lastErr = nil
  for i = 0, #RB_HOSTS - 1 do
    local idx = ((rbHost - 1 + i) % #RB_HOSTS) + 1
    local ok, body = pcall(httpGet, RB_HOSTS[idx] .. path)
    if ok and body and tostring(body) ~= "" and tostring(body) ~= "[]" then
      rbHost = idx
      return tostring(body)
    end
    lastErr = body
  end
  error(tostring(lastErr or "Radio Browser not reachable"))
end

local codeToCountry = {}
for name, codes in pairs(countryCodes) do
  local c = codes:match("^([^,]+)")
  if c then codeToCountry[c] = name end
end

local function rbStations(path)
  local body = rbGet(path)
  local out = {}
  local nObj = 0
  for obj in body:gmatch("%b{}") do
    nObj = nObj + 1
    if nObj % 100 == 0 then cooperate() end
    local name = obj:match('"name"%s*:%s*"([^"]*)"')
    local url = obj:match('"url_resolved"%s*:%s*"([^"]*)"')
    if not url or url == "" then url = obj:match('"url"%s*:%s*"([^"]*)"') end
    if name and url and url:match("^https?://") then
      name = unescapeJson(name):gsub("^%s+", ""):gsub("%s+$", "")
      url = unescapeJson(url)
      local country = unescapeJson(obj:match('"country"%s*:%s*"([^"]*)"') or "")
      local code = (obj:match('"countrycode"%s*:%s*"([^"]*)"') or ""):upper()
      local state = unescapeJson(obj:match('"state"%s*:%s*"([^"]*)"') or "")
      local lang = unescapeJson(obj:match('"language"%s*:%s*"([^"]*)"') or "")
      local tags = unescapeJson(obj:match('"tags"%s*:%s*"([^"]*)"') or "")
      local cname = codeToCountry[code] or country
      if name ~= "" then
        out[#out + 1] = {
          id = "rb:" .. url,
          url = url,
          title = name,
          sub = (state ~= "" and (state .. ", ") or "") .. cname,
          countryName = cname,
          code = code,
          src = "rb",
          language = lang,
          tags = tags,
        }
      end
    end
  end
  return out
end
local function parsePlaceBody(body, place, maxLookups, out, seenId, state)
  body = body:gsub("\\/", "/")
  local pos = 1
  while true do
    local a = body:find('"/listen/', pos, true)
    if not a then break end
    pos = a + 9
    local href = body:match('^"(/listen/[^"]*)"', a)
    local id = href and href:match("/listen/[^/]+/([^/]+)$")
    if id and not seenId[id] then
      seenId[id] = true
      local obj = enclosingObject(body, a)
      local title = unescapeJson(topField(obj, "title"))
      local pt = place.title:lower()
      if (title == "" or title:lower() == pt) and state.lookups < maxLookups then
        state.lookups = state.lookups + 1
        local info = channelInfo(id)
        if info and info.title ~= "" then title = info.title end
      end
      if title ~= "" then
        out[#out + 1] = {
          id = id,
          title = title,
          sub = place.title .. ((place.sub and place.sub ~= "") and (", " .. place.sub) or ""),
          countryName = place.sub or "",
          rank = place.rank or 0,
        }
      end
    end
  end
end

local function fetchPlaceChannels(place, maxLookups)
  maxLookups = maxLookups or 40
  local out, seenId = {}, {}
  local state = {lookups = 0}
  local base = "https://radio.garden/api/ara/content/page/" .. place.id
  local okFull, full = pcall(httpGet, base .. "/channels")
  if okFull then parsePlaceBody(tostring(full), place, maxLookups, out, seenId, state) end
  local okPage, page = pcall(httpGet, base)
  if okPage then parsePlaceBody(tostring(page), place, maxLookups, out, seenId, state) end
  if not okFull and not okPage then error("city page not available") end
  return out
end

runAsync = function(work, done)
  busyCount = busyCount + 1
  coopRun(work, function(ok, res)
    busyCount = busyCount - 1
    local okd, errd = pcall(done, ok, res)
    if not okd then toast("Error: " .. tostring(errd)) end
    scheduleExitCheck()
  end)
end

local function fixNames(all, cap)
  local lookups = 0
  cap = cap or 80
  for _, r in ipairs(all) do
    local first = (r.sub:lower():match("^%s*([^,]+)") or ""):gsub("%s+$", "")
    if lookups < cap and not r.url and (r.title == "" or r.title:lower() == first) then
      lookups = lookups + 1
      local info = channelInfo(r.id)
      if info and info.title ~= "" then
        r.title = info.title
        if info.place ~= "" then
          r.sub = info.place .. (info.country ~= "" and (", " .. info.country) or "")
        end
        if info.country ~= "" then r.countryName = info.country end
      end
    end
  end
end

local function normWord(w)
  w = tostring(w or ""):lower():gsub("[^%w]", "")
  w = w:gsub("(%a)%1+", "%1")
  w = w:gsub("ph", "f")
  w = w:gsub("w", "v")
  w = w:gsub("z", "s")
  w = w:gsub("q", "k")
  w = w:gsub("c", "k")
  w = w:gsub("y", "i")
  return w
end

local function lev(a, b, maxd)
  local la, lb = #a, #b
  if math.abs(la - lb) > maxd then return maxd + 1 end
  local prev = {}
  for j = 0, lb do prev[j] = j end
  for i = 1, la do
    local cur = {[0] = i}
    local best = i
    for j = 1, lb do
      local cost = (a:byte(i) == b:byte(j)) and 0 or 1
      local v = math.min(prev[j] + 1, cur[j-1] + 1, prev[j-1] + cost)
      cur[j] = v
      if v < best then best = v end
    end
    if best > maxd then return maxd + 1 end
    prev = cur
  end
  return prev[lb]
end

local skipWords = {fm = true, radio = true, station = true, channel = true, stations = true, channels = true}

local function wordsOf(input)
  local words = {}
  for w in tostring(input):lower():gmatch("%a+") do
    if not skipWords[w] and #w >= 3 then words[#words + 1] = w end
  end
  return words
end

local function matchesInput(text, input)
  local t = tostring(text):lower()
  local titleWords = {}
  for w in t:gmatch("%w+") do titleWords[#titleWords + 1] = normWord(w) end
  local joined = normWord(t)
  for w in tostring(input):lower():gmatch("[%w%.]+") do
    if not skipWords[w] then
      if w:match("^[%d%.]+$") then
        local base = w:gsub("%.0+$", "")
        local pat = "%f[%d]" .. base:gsub("%.", "%%.") .. "%f[%D]"
        if not t:find(pat) then return false end
      else
        local nw = normWord(w)
        local ok = false
        if #nw > 0 and joined:find(nw, 1, true) then
          ok = true
        else
          local maxd = (#nw >= 7 and 2) or (#nw >= 3 and 1) or 0
          if maxd > 0 then
            for _, tw in ipairs(titleWords) do
              if lev(nw, tw, maxd) <= maxd then ok = true break end
            end
          end
        end
        if not ok then return false end
      end
    end
  end
  return true
end

local scriptWords = {
["پاکستان"]="pakistan",["انڈیا"]="india",["بھارت"]="india",["امریکہ"]="united states",
["برطانیہ"]="united kingdom",["کینیڈا"]="canada",["ایران"]="iran",["افغانستان"]="afghanistan",
["بنگلہ دیش"]="bangladesh",["سعودی عرب"]="saudi arabia",["عرب امارات"]="united arab emirates",
["دبئی"]="dubai",["قطر"]="qatar",["کویت"]="kuwait",["ترکی"]="turkish",
["کراچی"]="karachi",["لاہور"]="lahore",["اسلام آباد"]="islamabad",["پشاور"]="peshawar",
["کوئٹہ"]="quetta",["ملتان"]="multan",["فیصل آباد"]="faisalabad",["راولپنڈی"]="rawalpindi",
["حیدرآباد"]="hyderabad",["سیالکوٹ"]="sialkot",["گوجرانوالہ"]="gujranwala",
["ریڈیو"]="radio",["ایف ایم"]="fm",
}

local brandWords = {
["آواز"]="awaz",["اواز"]="awaz",["سنو"]="suno",["ہم"]="hum",["مست"]="mast",["میرا"]="mera",
["سٹی"]="city",["سیٹی"]="city",["ہاٹ"]="hot",["بس"]="bus",["روز"]="rose",["جذبہ"]="jazba",
["ہیلو"]="hello",["گولڈ"]="gold",["پلس"]="plus",["ایکسپریس"]="express",["جیو"]="geo",
["دنیا"]="dunya",["سچ"]="sach",["خبریں"]="khabrain",["نیوز"]="news",["قرآن"]="quran",
["قران"]="quran",["اسلام"]="islam",["اسلامی"]="islamic",["مدنی"]="madani",["نعت"]="naat",
["قوالی"]="qawwali",["گانے"]="songs",["موسیقی"]="music",["ہٹ"]="hit",["دل"]="dil",
["پیار"]="pyar",["محبت"]="mohabbat",["صدا"]="sada",["پیغام"]="paigham",
["ریڈیو پاکستان"]="radio pakistan",["پاک"]="pak",["وطن"]="watan",["کشمیر"]="kashmir",
["سندھ"]="sindh",["پنجاب"]="punjab",["بلوچستان"]="balochistan",["خیبر"]="khyber",
["پختونخوا"]="pakhtunkhwa",["کابل"]="kabul",["ہرات"]="herat",["قندھار"]="kandahar",
["ابوظہبی"]="abu dhabi",["لندن"]="london",["دہلی"]="delhi",["ممبئی"]="mumbai",
}

local urduDict = {}
for k, v in pairs(scriptWords) do urduDict[k] = v end
for k, v in pairs(brandWords) do urduDict[k] = v end
for k, v in pairs(languageAliases) do
  if k:find("[\128-\255]") then urduDict[k] = v end
end

local letterMap = {
["ا"]="a",["آ"]="a",["ب"]="b",["پ"]="p",["ت"]="t",["ٹ"]="t",["ث"]="s",["ج"]="j",["چ"]="ch",
["ح"]="h",["خ"]="kh",["د"]="d",["ڈ"]="d",["ذ"]="z",["ر"]="r",["ڑ"]="r",["ز"]="z",["ژ"]="zh",
["س"]="s",["ش"]="sh",["ص"]="s",["ض"]="z",["ط"]="t",["ظ"]="z",["ع"]="a",["غ"]="gh",["ف"]="f",
["ق"]="q",["ک"]="k",["ك"]="k",["گ"]="g",["ل"]="l",["م"]="m",["ن"]="n",["ں"]="n",["ہ"]="h",
["ھ"]="h",["ه"]="h",["ۃ"]="h",["ء"]="",["ئ"]="i",["ؤ"]="o",["ے"]="e",["ۓ"]="e",
["ً"]="",["ٌ"]="",["ٍ"]="",["َ"]="",["ُ"]="",["ِ"]="",["ّ"]="",["ْ"]="",["‌"]="",["۔"]="",["،"]="",
["۰"]="0",["۱"]="1",["۲"]="2",["۳"]="3",["۴"]="4",["۵"]="5",["۶"]="6",["۷"]="7",["۸"]="8",["۹"]="9",
["٠"]="0",["١"]="1",["٢"]="2",["٣"]="3",["٤"]="4",["٥"]="5",["٦"]="6",["٧"]="7",["٨"]="8",["٩"]="9",
}

local function utf8Chars(s)
  local out = {}
  for ch in s:gmatch("[\1-\127\194-\244][\128-\191]*") do out[#out + 1] = ch end
  return out
end

local function translitWord(w)
  local chars = utf8Chars(w)
  local out = {}
  for i, ch in ipairs(chars) do
    if ch == "و" then
      local nx = chars[i + 1]
      if nx == "ا" or nx == "ی" or nx == "ے" or nx == "آ" then
        out[#out + 1] = "w"
      else
        out[#out + 1] = "o"
      end
    elseif ch == "ی" or ch == "ي" or ch == "ى" then
      out[#out + 1] = (i == #chars) and "i" or "y"
    elseif letterMap[ch] ~= nil then
      out[#out + 1] = letterMap[ch]
    else
      out[#out + 1] = ch
    end
  end
  return table.concat(out)
end

local function translateInput(q)
  q = tostring(q or "")
  local tokens = {}
  for w in q:gmatch("%S+") do tokens[#tokens + 1] = w end
  local out = {}
  local i = 1
  while i <= #tokens do
    local t1 = tokens[i]
    local t2 = tokens[i + 1]
    local two = t2 and (t1 .. " " .. t2) or nil
    if two and urduDict[two] then
      out[#out + 1] = urduDict[two]
      i = i + 2
    elseif urduDict[t1] then
      out[#out + 1] = urduDict[t1]
      i = i + 1
    elseif t1:find("[\128-\255]") then
      out[#out + 1] = translitWord(t1)
      i = i + 1
    else
      out[#out + 1] = t1
      i = i + 1
    end
  end
  local res = table.concat(out, " ")
  res = res:gsub("%s+", " ")
  res = res:gsub("^%s+", "")
  res = res:gsub("%s+$", "")
  return res
end

local languageCountryHints = {
urdu={"Pakistan","India"}, punjabi={"Pakistan","India"}, pashto={"Pakistan","Afghanistan"},
sindhi={"Pakistan","India"}, balochi={"Pakistan","Iran"}, saraiki={"Pakistan"},
hindi={"India","Nepal"}, bengali={"Bangladesh","India"}, tamil={"India","Sri Lanka"},
telugu={"India"}, marathi={"India"}, gujarati={"India"}, malayalam={"India"},
nepali={"Nepal","India"}, persian={"Iran","Afghanistan"}, turkish={"Turkey"},
arabic={"Saudi Arabia","Egypt","United Arab Emirates","Jordan","Iraq","Morocco"},
english={"United Kingdom","United States","Canada","Australia"},
french={"France","Canada"}, spanish={"Spain","Mexico","Argentina"},
german={"Germany","Austria"}, italian={"Italy"}, portuguese={"Portugal","Brazil"},
russian={"Russia","Kazakhstan"}, chinese={"China","Taiwan"}, japanese={"Japan"},
korean={"South Korea"},
}

local languageSearchNames = {
bengali={"bengali","bangla"}, persian={"persian","farsi"},
chinese={"chinese","mandarin","cantonese"}, urdu={"urdu"},
}

local function detectLanguage(q)
  local words = {}
  for w in tostring(q):lower():gmatch("%S+") do words[#words + 1] = w end
  if #words == 0 or #words > 3 then return nil end
  for _, w in ipairs(words) do
    if languageAliases[w] then return languageAliases[w] end
  end
  for _, w in ipairs(words) do
    if #w >= 6 and not w:find("%d") then
      for alias, key in pairs(languageAliases) do
        if not alias:find("[\128-\255]") and #alias >= 6 and lev(w, alias, 1) <= 1 then
          return key
        end
      end
    end
  end
  return nil
end

local function detectFrequency(q)
  local s = tostring(q):lower():gsub("^%s+", ""):gsub("%s+$", "")
  return s:match("^fm%s*(%d+%.?%d*)$")
    or s:match("^(%d+%.?%d*)%s*fm$")
    or s:match("^(%d+%.?%d*)%s*mhz$")
    or s:match("^frequency%s*(%d+%.?%d*)$")
    or s:match("^(%d+%.?%d*)$")
end

local function freqMatches(title, freq)
  local base = freq:gsub("%.0+$", "")
  local pat = "%f[%d]" .. base:gsub("%.", "%%.") .. "%f[%D]"
  return tostring(title):find(pat) ~= nil
end

local pkSearchCities = {"Karachi","Lahore","Islamabad","Rawalpindi","Faisalabad","Multan",
"Peshawar","Quetta","Sialkot","Gujranwala","Bahawalpur","Sargodha"}

local function newList()
  local list, seen = {}, {}
  local function add(q)
    q = tostring(q or "")
    if q ~= "" and not seen[q:lower()] then
      seen[q:lower()] = true
      list[#list + 1] = q
    end
  end
  return list, add
end

local function buildLanguageQueries(lang)
  local list, add = newList()
  local names = languageSearchNames[lang] or {lang}
  for _, n in ipairs(names) do
    for _, suffix in ipairs({"", " radio", " FM", " station", " online radio", " music", " news", " songs"}) do
      add(n .. suffix)
    end
  end
  for _, c in ipairs(languageCountryHints[lang] or {}) do
    add(c .. " " .. names[1])
    add(c .. " " .. names[1] .. " radio")
  end
  while #list > 30 do table.remove(list) end
  return list
end

local function buildFrequencyQueries(freq)
  local list, add = newList()
  add("FM " .. freq)
  add(freq .. " FM")
  add("FM" .. freq)
  add(freq)
  add(freq .. " MHz")
  add("Radio " .. freq)
  add(freq .. " radio")
  add("FM " .. freq .. " radio")
  if tonumber(freq) and math.floor(tonumber(freq)) == tonumber(freq) then
    add(string.format("%.1f FM", tonumber(freq)))
  end
  return list
end

local function buildQueries(input)
  local s = tostring(input):gsub("^%s+", ""):gsub("%s+$", "")
  local list, add = newList()
  add(s)
  add(s .. " FM")
  add(s .. " Radio")
  add(s .. " station")
  add((s:gsub("%s+", "")))
  local low = s:lower()
  local function addv(x) if x ~= low then add(x) end end
  addv((low:gsub("(%a)%1", "%1")))
  addv((low:gsub("w", "v")))
  addv((low:gsub("v", "w")))
  addv((low:gsub("z", "s")))
  addv((low:gsub("s", "z")))
  addv((low:gsub("ph", "f")))
  addv((low:gsub("q", "k")))
  addv((low:gsub("k", "q")))
  local longest = ""
  for w in low:gmatch("%a+") do
    if not skipWords[w] then
      if #w > #longest then longest = w end
      if w ~= low then
        add(w)
        add(w .. " FM")
      end
    end
  end
  if #longest >= 5 then add(longest:sub(1, 4)) end
  while #list > 16 do table.remove(list) end
  return list
end

local function normCountry(s)
  s = tostring(s or ""):lower()
  s = s:gsub("['`]", "")
  s = s:gsub("%-", " ")
  s = s:gsub("%s+", " ")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local countryGroups = {
{"czech republic","czechia"},{"turkey","turkiye","türkiye"},{"ivory coast","cote divoire","côte divoire"},
{"cape verde","cabo verde"},{"russia","russian federation"},{"eswatini","swaziland"},
{"timor leste","east timor"},{"north macedonia","macedonia"},{"myanmar","burma"},
{"palestine","palestinian territory"},{"united states","united states of america","usa"},
{"united kingdom","uk","great britain"},{"south korea","korea republic of","republic of korea"},
{"vatican city","holy see"},
}

local groupOf = {}
for gi, g in ipairs(countryGroups) do
  for _, n in ipairs(g) do groupOf[normCountry(n)] = gi end
end

local function wordSet(s)
  local set, n = {}, 0
  for w in s:gmatch("%S+") do
    set[w] = true
    n = n + 1
  end
  return set, n
end

local function countryMatches(actual, wanted)
  local a, w = normCountry(actual), normCountry(wanted)
  if a == "" or w == "" then return false end
  if a == w then return true end
  if groupOf[a] and groupOf[a] == groupOf[w] then return true end
  local sa, na = wordSet(a)
  local sw, nw = wordSet(w)
  if nw >= 2 then
    local all = true
    for k in pairs(sw) do if not sa[k] then all = false break end end
    if all then return true end
  end
  if na >= 2 then
    local all = true
    for k in pairs(sa) do if not sw[k] then all = false break end end
    if all then return true end
  end
  return false
end

local countryShort = {
uk="United Kingdom",britain="United Kingdom",england="United Kingdom",
usa="United States",us="United States",america="United States",
uae="United Arab Emirates",emirates="United Arab Emirates",ksa="Saudi Arabia",
saudi="Saudi Arabia",korea="South Korea",holland="Netherlands",srilanka="Sri Lanka",
}

local function detectCountry(q)
  q = tostring(q):lower()
  if q:find("%d") then return nil end
  local words = {}
  for w in q:gmatch("%a+") do
    if not skipWords[w] then words[#words + 1] = w end
  end
  if #words == 0 or #words > 4 then return nil end
  local joined = table.concat(words, " ")
  local compact = table.concat(words)
  if countryShort[compact] then return countryShort[compact] end
  for _, name in ipairs(countryNames) do
    if countryMatches(name, joined) then return name end
  end
  if #compact == 3 then
    for _, name in ipairs(countryNames) do
      local codes = countryCodes[name] or ""
      for c in codes:gmatch("[^,]+") do
        if #c == 3 and c:lower() == compact then return name end
      end
    end
  end
  if #compact >= 6 then
    local nc = normWord(compact)
    for _, name in ipairs(countryNames) do
      if #name >= 6 and lev(nc, normWord(name), 1) <= 1 then return name end
    end
  end
  return nil
end

local knownCountries = {}
for _, n in ipairs(countryNames) do knownCountries[normCountry(n)] = true end
for k in pairs(groupOf) do knownCountries[k] = true end

local function resolveCountries(all, gl)
  local best = {}
  for _, p in ipairs(gl or {}) do
    local k = normCountry(p.title)
    local cur = best[k]
    if not cur or (p.size or 0) > cur.size then
      best[k] = {country = p.sub, size = p.size or 0}
    end
  end
  local nAll = 0
  for _, r in ipairs(all) do
    nAll = nAll + 1
    if nAll % 200 == 0 then cooperate() end
    if not r.countryName or r.countryName == "" then
      local sub = tostring(r.sub or "")
      local after = sub:match(",%s*([^,]+)$")
      if after and knownCountries[normCountry(after)] then
        r.countryName = after
      else
        local first = sub:match("^%s*([^,]+)")
        local b = first and best[normCountry(first)]
        if b then r.countryName = b.country end
      end
    end
  end
end

local function isHome(r)
  local home = getHome()
  if r.countryName and r.countryName ~= "" and countryMatches(r.countryName, home) then
    return true
  end
  local sub = tostring(r.sub or ""):lower()
  if sub:find(home:lower(), 1, true) then return true end
  local code = tostring(r.code or "")
  if code ~= "" and code == homeIso() then return true end
  return false
end

local function homeCities(gl)
  local n = 12
  local home = getHome()
  local pl = {}
  for _, p in ipairs(gl or {}) do
    if countryMatches(p.sub, home) then pl[#pl + 1] = p end
  end
  table.sort(pl, function(a, b) return (a.size or 0) > (b.size or 0) end)
  local out, seenT = {}, {}
  for _, p in ipairs(pl) do
    if #out >= n then break end
    local k = p.title:lower()
    if not seenT[k] then
      seenT[k] = true
      out[#out + 1] = p.title
    end
  end
  if #out == 0 and home == "Pakistan" then
    for i = 1, math.min(n, #pkSearchCities) do out[#out + 1] = pkSearchCities[i] end
  end
  return out
end

local function dedupeStations(all)
  local out, seenK = {}, {}
  local nAll = 0
  for _, r in ipairs(all) do
    nAll = nAll + 1
    if nAll % 200 == 0 then cooperate() end
    local k = normWord(r.title) .. "|" .. normCountry(r.countryName or "") .. "|" ..
      normWord((tostring(r.sub or ""):match("^%s*([^,]+)") or ""))
    if not seenK[k] then
      seenK[k] = true
      out[#out + 1] = r
    end
  end
  return out
end

local function relevance(r, q)
  local nq = normWord((tostring(q):gsub("%f[%a][Ff][Mm]%f[%A]", "")))
  local full = normWord(q)
  local nt = normWord(r.title)
  if nt == full or (nq ~= "" and nt == nq) then return 300 end
  if full ~= "" and nt:sub(1, #full) == full then return 250 end
  if full ~= "" and nt:find(full, 1, true) then return 200 end
  if nq ~= "" and nt:find(nq, 1, true) then return 150 end
  return 100
end

local function cityOf(r)
  return (tostring(r.sub or ""):lower():match("^%s*([^,]+)") or "")
end

local function sortList(list)
  for i, r in ipairs(list) do
    r.order = i
    r.num = tonumber(tostring(r.title or ""):match("(%d+%.?%d*)")) or 100000
    r.rank = r.rank or 0
    r.score = r.score or 0
    r.lname = tostring(r.title or ""):lower()
    local base = r.lname:gsub("[%d%.]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    r.base = base
    r.city = cityOf(r)
  end
  table.sort(list, function(a, b)
    if a.score ~= b.score then return a.score > b.score end
    if a.base ~= b.base then return a.base < b.base end
    if a.num ~= b.num then return a.num < b.num end
    if a.city ~= b.city then return a.city < b.city end
    return a.order < b.order
  end)
end

local function showResults(title, list, backFn, note)
  local home = getHome()
  local iso = homeIso()
  local hm, other = {}, {}
  for _, r in ipairs(list) do
    r.home = isHome(r)
    if r.home then hm[#hm + 1] = r else other[#other + 1] = r end
  end
  local ordered = {}
  if settings.homeFirst then
    sortList(hm)
    sortList(other)
    for _, r in ipairs(hm) do ordered[#ordered + 1] = r end
    for _, r in ipairs(other) do ordered[#ordered + 1] = r end
  else
    for _, r in ipairs(list) do ordered[#ordered + 1] = r end
    sortList(ordered)
  end
  local tag = (settings.tags and iso ~= "") and ("[" .. iso .. "] ") or ""
  local channels = {}
  for _, r in ipairs(ordered) do
    channels[#channels + 1] = {
      name = (r.home and tag or "") .. r.title .. ((r.sub and r.sub ~= "") and (" - " .. r.sub) or ""),
      url = r.url or (RG .. r.id .. "/channel.mp3"),
    }
  end
  local summary = #channels .. " channels in total, " .. #hm .. " from " .. home
  local suffix = (note or "")
  if addTargetCat then
    suffix = suffix .. "  [Tap a channel to add to " .. addTargetCat.name .. "]"
  end
  toast(title .. ": " .. summary .. suffix)
  showChannels({name = title .. " - " .. summary .. suffix, channels = channels, isResults = true}, backFn)
end

local function loadCountryChannels(country, gl, minCities, startRank, budgetSec)
  local pl = {}
  for _, p in ipairs(gl or {}) do
    if countryMatches(p.sub, country) then pl[#pl + 1] = p end
  end
  table.sort(pl, function(a, b) return (a.size or 0) > (b.size or 0) end)
  local out, n = {}, 0
  local startT = os.time()
  budgetSec = budgetSec or 90
  for i, p in ipairs(pl) do
    if n >= minCities and (os.time() - startT) >= budgetSec then break end
    n = n + 1
    p.rank = (startRank or 0) + i
    local ok, list = pcall(fetchPlaceChannels, p, 3)
    if ok then
      for _, r in ipairs(list) do
        r.countryName = country
        out[#out + 1] = r
      end
    end
  end
  return out, #pl, n
end

local function smartSearch(input, backFn, forcedCountry, forcedType)
  closeDialog()
  local q0 = translateInput(input)
  local freq, lang = nil, nil
  if forcedType == "frequency" then
    freq = detectFrequency(q0) or q0:match("^(%d+%.?%d*)")
    if not freq then
      toast("Please type a frequency like 101 or FM 101")
      if backFn then backFn() end
      return
    end
  elseif forcedType == "language" then
    lang = detectLanguage(q0)
    if not lang then
      for w in q0:lower():gmatch("%S+") do
        if languageAliases[w] then lang = languageAliases[w] break end
      end
    end
    if not lang then
      toast("Unknown language. Try: urdu, english, arabic, hindi ...")
      if backFn then backFn() end
      return
    end
  elseif forcedType == "city" or forcedType == "name" then
  else
    freq = (not forcedCountry) and detectFrequency(q0) or nil
    lang = (not forcedCountry and not freq) and detectLanguage(q0) or nil
  end
  toast("Searching: " .. input .. " (please wait, this can take a while)")
  runAsync(function()
    local gl = nil
    do
      local okp, res = pcall(getAllPlaces)
      if okp then gl = res end
    end
    local hc = homeCities(gl)
    local seen, all = {}, {}
    local hitPlaces, placeSeen = {}, {}
    local okCount, lastErr = 0, nil
    local function addAll(list)
      for _, r in ipairs(list or {}) do
        if r.id and not seen[r.id] then
          seen[r.id] = true
          all[#all + 1] = r
        end
      end
    end
    local function runQueries(qs)
      for _, q in ipairs(qs) do
        local ok, res, raw, smp, pl = pcall(searchRadioGarden, q)
        if ok then
          okCount = okCount + 1
          addAll(res)
          for _, p in ipairs(pl or {}) do
            if not placeSeen[p.id] then
              placeSeen[p.id] = true
              hitPlaces[#hitPlaces + 1] = p
            end
          end
        else
          lastErr = tostring(res)
        end
      end
    end
    local rbCount = 0
    local function rbAdd(path, score)
      if not settings.rb then return end
      local ok, list = pcall(rbStations, path)
      if ok then
        okCount = okCount + 1
        for _, r in ipairs(list) do
          if score then r.score = score end
          if not seen[r.id] then
            seen[r.id] = true
            all[#all + 1] = r
            rbCount = rbCount + 1
          end
        end
      else
        lastErr = tostring(list)
      end
    end
    local rbTail = "?hidebroken=true&limit=3000&order=votes&reverse=true"
    local budget = 90
    local mode, modeName, extraNote = "text", input, ""
    local country = forcedCountry
    if not country and not freq and not lang and not forcedType then
      country = detectCountry(q0)
    end
    if country then
      mode, modeName = "country", country
      local list, cityTotal, cityLoaded = loadCountryChannels(country, gl, settings.countryCap, 0, budget)
      addAll(list)
      okCount = 1
      local fromPages = #all
      local extra = {country, country .. " radio", country .. " FM", country .. " news",
      country .. " music", country .. " radio station", country .. " online radio"}
      local nPlaces = 10
      local plist = {}
      for _, p in ipairs(gl or {}) do
        if countryMatches(p.sub, country) then plist[#plist + 1] = p end
      end
      table.sort(plist, function(a, b) return (a.size or 0) > (b.size or 0) end)
      for i = 1, math.min(nPlaces, #plist) do
        extra[#extra + 1] = plist[i].title .. " FM"
        extra[#extra + 1] = plist[i].title .. " radio"
      end
      local keepAll, keepSeen = all, seen
      all, seen = {}, {}
      runQueries(extra)
      local cands = all
      all, seen = keepAll, keepSeen
      resolveCountries(cands, gl)
      for _, r in ipairs(cands) do
        local ok1 = r.countryName and r.countryName ~= "" and countryMatches(r.countryName, country)
        local ok2 = tostring(r.sub or ""):lower():find(country:lower(), 1, true) ~= nil
        if ok1 or ok2 then
          r.countryName = country
          addAll({r})
        end
      end
      local fromSearch = #all - fromPages
      local iso = (countryCodes[country] or ""):match("^([^,]+)")
      if iso then rbAdd("/json/stations/bycountrycodeexact/" .. iso .. rbTail:gsub("limit=3000", "limit=10000")) end
      extraNote = " (" .. cityLoaded .. " of " .. cityTotal .. " cities, " .. fromPages ..
        " from city pages, " .. fromSearch .. " from search, " .. rbCount .. " from Radio Browser)"
    elseif lang then
      mode, modeName = "language", lang
      local names = languageSearchNames[lang] or {lang}
      for _, n in ipairs(names) do
        rbAdd("/json/stations/bylanguage/" .. urlEnc(n) .. rbTail, 150)
      end
      for _, n in ipairs(names) do
        rbAdd("/json/stations/byLanguageExact/" .. urlEnc(n) .. rbTail, 150)
      end
      for _, n in ipairs(names) do
        local sep = rbTail:sub(1, 1) == "?" and "&" or "?"
        local langQuery = "/json/stations/search" .. rbTail .. sep .. "language=" .. urlEnc(n)
        rbAdd(langQuery, 145)
      end
      runQueries(buildLanguageQueries(lang))
      for _, r in ipairs(all) do
        if not r.score or r.score == 0 then
          local text = (r.title .. " " .. r.sub):lower()
          r.score = 0
          for _, n in ipairs(names) do
            if text:find(n, 1, true) then r.score = 100 end
          end
        end
      end
      local hints = languageCountryHints[lang] or {}
      for i = 1, math.min(2, #hints) do
        addAll((loadCountryChannels(hints[i], gl, 15, 100 * i, 30)))
      end
      extraNote = " (" .. rbCount .. " stations marked with this language by Radio Browser)"
    elseif freq then
      mode, modeName = "frequency", freq
      local qs = buildFrequencyQueries(freq)
      for _, c in ipairs(hc) do qs[#qs + 1] = "FM " .. freq .. " " .. c end
      runQueries(qs)
      for _, q in ipairs({"FM " .. freq, freq .. " FM", "FM" .. freq, freq}) do
        rbAdd("/json/stations/byname/" .. urlEnc(q) .. rbTail)
      end
    else
      do
        local rbq, rbSeen = {}, {}
        local function addq(q)
          q = cleanName(q)
          if q ~= "" and not rbSeen[q:lower()] and #rbq < 14 then
            rbSeen[q:lower()] = true
            rbq[#rbq + 1] = q
          end
        end
        addq(q0)
        addq(input)
        addq((q0:gsub("%s+", "")))
        local longest = ""
        for w in q0:lower():gmatch("[%w]+") do
          if not skipWords[w] and #w >= 3 then
            addq(w)
            if #w > #longest and not w:match("^%d+$") then longest = w end
          end
        end
        if #longest >= 3 then
          addq((longest:gsub("(%a)%1", "%1")))
          addq((longest:gsub("w", "v")))
          addq((longest:gsub("v", "w")))
          addq((longest:gsub("z", "s")))
          addq((longest:gsub("s", "z")))
          addq((longest:gsub("k", "q")))
          addq((longest:gsub("q", "k")))
          addq((longest:gsub("ph", "f")))
          addq((longest:gsub("([aeiou])", "%1%1", 1)))
          addq((longest:gsub("([aeiou])([^aeiou]*)$", "%1%1%2", 1)))
          if #longest >= 5 then addq(longest:sub(1, 4)) end
        end
        for _, q in ipairs(rbq) do
          rbAdd("/json/stations/byname/" .. urlEnc(q) .. rbTail:gsub("limit=3000", "limit=1500"))
        end
      end
      runQueries(buildQueries(q0))
      local words = wordsOf(q0)
      local loadedCity = false
      if #words > 0 then
        local pool, poolSeen = {}, {}
        for _, p in ipairs(hitPlaces) do
          poolSeen[p.id] = true
          pool[#pool + 1] = p
        end
        for _, p in ipairs(gl or {}) do
          if not poolSeen[p.id] then pool[#pool + 1] = p end
        end
        local matched = {}
        for _, p in ipairs(pool) do
          local ptj = normWord(p.title)
          local hit = false
          if ptj ~= "" then
            if normWord(table.concat(words)) == ptj then hit = true end
            for _, w in ipairs(words) do
              local nw = normWord(w)
              if nw == ptj or (#nw >= 5 and #ptj >= 5 and lev(nw, ptj, 1) <= 1) then hit = true end
            end
          end
          if hit then matched[#matched + 1] = p end
        end
        table.sort(matched, function(a, b)
          local ap = (a.sub == "Pakistan" or a.code == "PK") and 0 or 1
          local bp = (b.sub == "Pakistan" or b.code == "PK") and 0 or 1
          if ap ~= bp then return ap < bp end
          return (a.size or 0) > (b.size or 0)
        end)
        local cityNames = {}
        for i = 1, math.min(#matched, 3) do
          matched[i].rank = i
          local okc, list = pcall(fetchPlaceChannels, matched[i], 40)
          if okc then
            cityNames[#cityNames + 1] = matched[i].title
            addAll(list)
          end
        end
        if #cityNames > 0 then
          loadedCity = true
          mode, modeName = "city", table.concat(cityNames, ", ")
          local c = cityNames[1]
          local sweep = {c .. " FM", c .. " Radio"}
          for _, f in ipairs({"87.6","88","89","90","91","92","93","94","95","96","97","98","99",
            "100","101","102","103","104","105","106","107","107.4"}) do
            sweep[#sweep + 1] = "FM " .. f .. " " .. c
          end
          for _, sq in ipairs(sweep) do
            local oks, res = pcall(searchRadioGarden, sq)
            if oks then
              local fresh = {}
              for _, r in ipairs(res) do
                local first = (r.sub:lower():match("^%s*([^,]+)") or "")
                if first == c:lower() then fresh[#fresh + 1] = r end
              end
              addAll(fresh)
            end
          end
        end
      end
      if not loadedCity then
        local qs = {}
        for _, c in ipairs(hc) do qs[#qs + 1] = q0 .. " " .. c end
        runQueries(qs)
      end
    end
    fixNames(all, (mode == "country") and 150 or 80)
    resolveCountries(all, gl)
    all = dedupeStations(all)
    return {mode = mode, modeName = modeName, all = all, okCount = okCount, err = lastErr,
    note = extraNote, freq = freq}
  end, function(ok, res)
    if not ok then
      toast("Search failed: " .. tostring(res))
      if backFn then backFn() end
      return
    end
    if res.okCount == 0 and #res.all == 0 then
      toast("Search failed (check internet): " .. tostring(res.err))
      if backFn then backFn() end
      return
    end
    local chosen = res.all
    local note = res.note or ""
    if res.mode == "text" or res.mode == "city" then
      local filtered = {}
      for _, r in ipairs(res.all) do
        local text = r.title .. " " .. r.sub
        if matchesInput(text, q0) or (input ~= q0 and matchesInput(text, input)) then
          filtered[#filtered + 1] = r
        end
      end
      if #filtered > 0 then
        chosen = filtered
      elseif #res.all > 0 then
        note = " (no station with this name found, showing similar)"
      end
      for _, r in ipairs(chosen) do
        local s1 = relevance(r, q0)
        local s2 = (input ~= q0) and relevance(r, input) or 0
        r.score = math.max(s1, s2)
      end
    elseif res.mode == "frequency" then
      local filtered = {}
      for _, r in ipairs(res.all) do
        if freqMatches(r.title, res.modeName) then filtered[#filtered + 1] = r end
      end
      chosen = filtered
    end
    if #chosen == 0 then
      toast("No channels found for: " .. input)
      if backFn then backFn() end
      return
    end
    local label = ({country = "Country ", city = "City ", language = "Language ",
    frequency = "Frequency ", text = "Results: "})[res.mode] .. res.modeName
    showResults(label, chosen, backFn, note)
  end)
end

-- Newer Android versions call onLocationChanged with a List<Location> instead of a
-- single Location, so accept both.
function pickLocation(loc)
  if loc == nil then return nil end
  local okLat, lat = pcall(function() return loc.getLatitude() end)
  if okLat and lat then return loc end
  local r = nil
  pcall(function()
    local n = loc.size()
    if n > 0 then r = loc.get(n - 1) end
  end)
  return r
end

local function getCurrentLocation(cb)
  local hasPermission = false
  pcall(function()
    local pm = ctx.checkSelfPermission("android.permission.ACCESS_FINE_LOCATION")
    hasPermission = (pm == 0)
  end)
  if not hasPermission then
    pcall(function()
      if activity then
        activity.requestPermissions({"android.permission.ACCESS_FINE_LOCATION", "android.permission.ACCESS_COARSE_LOCATION"}, 9001)
      elseif ctx.requestPermissions then
        ctx.requestPermissions({"android.permission.ACCESS_FINE_LOCATION", "android.permission.ACCESS_COARSE_LOCATION"}, 9001)
      end
    end)
    toast("Please allow location permission, then try again")
    cb(nil, nil)
    return
  end
  local got = false
  local function tryReturn(lat, lon)
    if got then return end
    got = true
    cb(lat, lon)
  end
  pcall(function()
    local lm = ctx.getSystemService(Context.LOCATION_SERVICE)
    local last = nil
    for _, p in ipairs({"gps", "network", "passive"}) do
      local loc = lm.getLastKnownLocation(p)
      if loc then last = loc break end
    end
    if last then
      tryReturn(last.getLatitude(), last.getLongitude())
    end
  end)
  pcall(function()
    local lm = ctx.getSystemService(Context.LOCATION_SERVICE)
    local listener = nil
    listener = proxy("android.location.LocationListener", {
      onLocationChanged = function(loc)
        pcall(function() lm.removeUpdates(listener) end)
        local l = pickLocation(loc)
        if l then
          tryReturn(l.getLatitude(), l.getLongitude())
        end
      end,
      onStatusChanged = function(a, b, c) end,
      onProviderEnabled = function(a) end,
      onProviderDisabled = function(a) end,
    })
    local provider = "network"
    pcall(function()
      if lm.isProviderEnabled("gps") then provider = "gps" end
    end)
    lm.requestLocationUpdates(provider, 0, 0, listener, Looper.getMainLooper())
    local hh = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
    hh.postDelayed(proxy("java.lang.Runnable", {
      run = function()
        pcall(function() lm.removeUpdates(listener) end)
        if not got then tryReturn(nil, nil) end
      end
    }), 8000)
  end)
end

local function getCountryFromCoords(lat, lon)
  local result, iso = nil, nil
  pcall(function()
    local url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=" ..
      tostring(lat) .. "&lon=" .. tostring(lon) .. "&zoom=3&addressdetails=1&accept-language=en"
    local geo = tostring(httpGet(url))
    local cn = geo:match('"country"%s*:%s*"([^"]*)"')
    local cc = geo:match('"country_code"%s*:%s*"([^"]*)"')
    if cn then result = cn end
    if cc then iso = cc end
  end)
  return result, iso
end

-- Finds the country you are in right now (GPS / network location, uses the
-- location permission already granted to the host app) and makes it the home country.
function updateLocationCountry(onDone)
  local st = _locState
  local function fin()
    if onDone then pcall(onDone) end
  end
  if not settings.useLocation or st.busy then fin() return end
  local hasPerm = false
  pcall(function()
    hasPerm = (ctx.checkSelfPermission("android.permission.ACCESS_FINE_LOCATION") == 0)
      or (ctx.checkSelfPermission("android.permission.ACCESS_COARSE_LOCATION") == 0)
  end)
  if not hasPerm then fin() return end
  local okLm, lm = pcall(function() return ctx.getSystemService(Context.LOCATION_SERVICE) end)
  if not okLm or not lm then fin() return end
  st.busy = true
  local best, bestTime = nil, 0
  pcall(function()
    for _, p in ipairs({"gps", "network", "passive"}) do
      local loc = lm.getLastKnownLocation(p)
      if loc and loc.getTime() > bestTime then best = loc bestTime = loc.getTime() end
    end
  end)
  local done = false
  local listener = nil
  local function finish(lat, lon)
    if done then return end
    done = true
    if listener then pcall(function() lm.removeUpdates(listener) end) end
    if not lat or not lon then
      st.busy = false
      fin()
      return
    end
    runAsync(function()
      local name, iso = getCountryFromCoords(lat, lon)
      return {name = name, iso = iso}
    end, function(ok, res)
      st.busy = false
      if ok and res then
        local cn = isoToCountryName(res.iso)
        if not cn and res.name then
          for _, n in ipairs(countryNames) do
            if n:lower() == tostring(res.name):lower() then cn = n break end
          end
        end
        if cn then
          st.fresh, st.saved, st.cached = cn, cn, nil
          prefSet("lastloc", cn)
        end
      end
      fin()
    end)
  end
  local ageMs = 0
  pcall(function() ageMs = Sys.currentTimeMillis() - bestTime end)
  if best and ageMs < 600000 then
    finish(best.getLatitude(), best.getLongitude())
    return
  end
  local function fallback()
    if best then finish(best.getLatitude(), best.getLongitude()) else finish(nil, nil) end
  end
  local requested = false
  pcall(function()
    listener = proxy("android.location.LocationListener", {
      onLocationChanged = function(loc)
        local l = pickLocation(loc)
        if l then
          finish(l.getLatitude(), l.getLongitude())
        end
      end,
      onStatusChanged = function(a, b, c) end,
      onProviderEnabled = function(a) end,
      onProviderDisabled = function(a) end,
    })
    for _, prov in ipairs({"gps", "network"}) do
      pcall(function()
        if lm.isProviderEnabled(prov) then
          lm.requestLocationUpdates(prov, 0, 0, listener, Looper.getMainLooper())
          requested = true
        end
      end)
    end
  end)
  if not requested then fallback() return end
  local hh = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
  hh.postDelayed(proxy("java.lang.Runnable", {
    run = function() fallback() end
  }), 8000)
end

local function nearbySearch(backFn)
  closeDialog()
  toast("Getting your location...")
  getCurrentLocation(function(lat, lon)
    if not lat or not lon then
      toast("Could not get your location. Enable GPS and try again.")
      if backFn then backFn() end
      return
    end
    toast("Searching near your location...")
    runAsync(function()
      local url1 = "/json/stations/search?geo_lat=" .. tostring(lat) ..
        "&geo_long=" .. tostring(lon) ..
        "&geo_distance=150&limit=300&hidebroken=true&order=votes&reverse=true"
      local ok1, list1 = pcall(rbStations, url1)
      if ok1 and list1 and #list1 > 0 then
        return {stage = "nearby", list = list1}
      end
      local url2 = "/json/stations/search?geo_lat=" .. tostring(lat) ..
        "&geo_long=" .. tostring(lon) ..
        "&geo_distance=500&limit=300&hidebroken=true&order=votes&reverse=true"
      local ok2, list2 = pcall(rbStations, url2)
      if ok2 and list2 and #list2 > 0 then
        return {stage = "region", list = list2}
      end
      local geoCountry, geoIso = getCountryFromCoords(lat, lon)
      if geoCountry then
        local iso = (geoIso and geoIso ~= "") and geoIso:upper() or nil
        if iso and isoToCountryName(iso) then geoCountry = isoToCountryName(iso) end
        if not iso then
          for _, name in ipairs(countryNames) do
            if name:lower() == geoCountry:lower() then
              iso = (countryCodes[name] or ""):match("^([^,]+)")
              break
            end
          end
        end
        if iso then
          local ok3, list3 = pcall(rbStations, "/json/stations/bycountrycodeexact/" .. iso ..
            "?hidebroken=true&limit=300&order=votes&reverse=true")
          if ok3 and list3 and #list3 > 0 then
            return {stage = "country", list = list3, countryName = geoCountry}
          end
        end
      end
      local hIso = homeIso()
      if hIso and hIso ~= "" then
        local ok4, list4 = pcall(rbStations, "/json/stations/bycountrycodeexact/" .. hIso ..
          "?hidebroken=true&limit=300&order=votes&reverse=true")
        if ok4 and list4 and #list4 > 0 then
          return {stage = "homecountry", list = list4, countryName = getHome()}
        end
      end
      local ok5, list5 = pcall(rbStations, "/json/stations/search?limit=200&hidebroken=true&order=votes&reverse=true")
      if ok5 and list5 and #list5 > 0 then
        return {stage = "world", list = list5}
      end
      return {stage = "none", list = {}}
    end, function(ok, res)
      if not ok or not res or #res.list == 0 then
        toast("No stations found. Please check your internet connection.")
        if backFn then backFn() end
        return
      end
      local channels = {}
      for _, r in ipairs(res.list) do
        channels[#channels + 1] = {
          name = r.title .. ((r.sub and r.sub ~= "") and (" - " .. r.sub) or ""),
          url = r.url,
        }
      end
      local stageLabel
      if res.stage == "nearby" then
        stageLabel = "Nearby Stations (within 150 km)"
      elseif res.stage == "region" then
        stageLabel = "Nearby Stations (within 500 km)"
      elseif res.stage == "country" then
        stageLabel = "Stations in " .. (res.countryName or "your country")
      elseif res.stage == "homecountry" then
        stageLabel = "Stations in " .. (res.countryName or getHome())
      else
        stageLabel = "Popular Stations Worldwide"
      end
      toast(#channels .. " stations found")
      showChannels({
        name = stageLabel .. " (" .. #channels .. ")",
        channels = channels,
        isResults = true,
      }, backFn)
    end)
  end)
end

local function makeListDialog(title, items, onClick, backFn, onLong)
  local list = ArrayList()
  for i = 1, #items do list.add(items[i]) end
  local adapter = ArrayAdapter(ctx, android.R.layout.simple_list_item_1, list)
  local lv = ListView(ctx)
  lv.setAdapter(adapter)
  local b = AlertDialog.Builder(ctx)
  b.setTitle(title)
  b.setView(lv)
  if playerActive() then
    b.setPositiveButton("Stop", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w)
        stopPlayer()
        toast("Radio stopped")
        if refreshCurrent then refreshCurrent() end
      end)
    }))
  end
  if backFn then
    b.setNeutralButton("Back", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w) backFn() end)
    }))
  end
  b.setNegativeButton("Close", nil)
  local dlg = b.create()
  lv.setOnItemClickListener(proxy("android.widget.AdapterView$OnItemClickListener", {
    onItemClick = guard(function(parent, view, position, id) onClick(position + 1) end)
  }))
  if onLong then
    lv.setOnItemLongClickListener(proxy("android.widget.AdapterView$OnItemLongClickListener", {
      onItemLongClick = function(parent, view, position, id)
        guard(function() onLong(position + 1) end)()
        return true
      end
    }))
  end
  return dlg
end

local function makeListDialogWithTopButtons(title, topButtons, items, onClick, backFn, onLong)
  local root = LinearLayout(ctx)
  root.setOrientation(LinearLayout.VERTICAL)
  local buttonBar = LinearLayout(ctx)
  buttonBar.setOrientation(LinearLayout.VERTICAL)
  buttonBar.setPadding(16, 14, 16, 6)
  root.addView(buttonBar, LinearLayout.LayoutParams(-1, -2))
  for _, tb in ipairs(topButtons) do
    local btn = Button(ctx)
    btn.setText(tb.text)
    local lp = LinearLayout.LayoutParams(-1, -2)
    lp.bottomMargin = 8
    buttonBar.addView(btn, lp)
    btn.setOnClickListener(proxy("android.view.View$OnClickListener", {
      onClick = guard(function() tb.onClick() end)
    }))
  end
  local list = ArrayList()
  for i = 1, #items do list.add(items[i]) end
  local adapter = ArrayAdapter(ctx, android.R.layout.simple_list_item_1, list)
  local lv = ListView(ctx)
  lv.setAdapter(adapter)
  root.addView(lv, LinearLayout.LayoutParams(-1, 0, 1))
  local b = AlertDialog.Builder(ctx)
  b.setTitle(title)
  b.setView(root)
  if playerActive() then
    b.setPositiveButton("Stop", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w)
        stopPlayer()
        toast("Radio stopped")
        if refreshCurrent then refreshCurrent() end
      end)
    }))
  end
  if backFn then
    b.setNeutralButton("Back", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w) backFn() end)
    }))
  end
  b.setNegativeButton("Close", nil)
  local dlg = b.create()
  lv.setOnItemClickListener(proxy("android.widget.AdapterView$OnItemClickListener", {
    onItemClick = guard(function(parent, view, position, id) onClick(position + 1) end)
  }))
  if onLong then
    lv.setOnItemLongClickListener(proxy("android.widget.AdapterView$OnItemLongClickListener", {
      onItemLongClick = function(parent, view, position, id)
        guard(function() onLong(position + 1) end)()
        return true
      end
    }))
  end
  return dlg
end

local function confirmDialog(msg, onYes)
  local b = AlertDialog.Builder(ctx)
  b.setTitle("Confirm")
  b.setMessage(msg)
  b.setPositiveButton("Yes", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function(d, w) onYes() end)
  }))
  b.setNegativeButton("Cancel", nil)
  showOverlay(b.create())
end

local function askListName(initial, cb)
  local input = EditText(ctx)
  input.setSingleLine(true)
  input.setHint("List name")
  input.setText(initial or "")
  local b = AlertDialog.Builder(ctx)
  b.setTitle((initial and initial ~= "") and "Rename list" or "New list")
  b.setView(input)
  b.setPositiveButton("Save", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function(d, w)
      local name = cleanName(tostring(input.getText()))
      if name == "" then
        toast("Type a name for the list")
      else
        cb(name)
      end
    end)
  }))
  b.setNegativeButton("Cancel", nil)
  showOverlay(b.create())
end

-- ============ Custom Channel Add Dialog ============
-- ایڈ کرنے کے بعد ڈائلاگ بند ہو کر سیدھا کسٹم چینلز کی لسٹ کھل جاتی ہے
local function askAddCustomChannel()
  local root = LinearLayout(ctx)
  root.setOrientation(LinearLayout.VERTICAL)
  root.setPadding(20, 10, 20, 10)

  local hintTv = TextView(ctx)
  hintTv.setText("Enter a name and a live stream link.")
  hintTv.setTextSize(12)
  root.addView(hintTv, LinearLayout.LayoutParams(-1, -2))

  local nameBox = EditText(ctx)
  nameBox.setSingleLine(true)
  nameBox.setHint("Channel name")
  root.addView(nameBox, LinearLayout.LayoutParams(-1, -2))

  local urlBox = EditText(ctx)
  urlBox.setSingleLine(true)
  urlBox.setHint("Live stream link")
  root.addView(urlBox, LinearLayout.LayoutParams(-1, -2))

  local statusTv = TextView(ctx)
  statusTv.setTextSize(12)
  root.addView(statusTv, LinearLayout.LayoutParams(-1, -2))

  local b = AlertDialog.Builder(ctx)
  b.setTitle("Add custom channel")
  b.setView(root)
  b.setPositiveButton("Add", nil)
  b.setNegativeButton("Cancel", nil)
  local dlg = b.create()

  if not showOverlay(dlg) then return end

  local okBtn, addBtn = pcall(function() return dlg.getButton(-1) end)
  if not okBtn or addBtn == nil then
    toast("Add button not available")
    return
  end
  addBtn.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      local url = extractUrl(tostring(urlBox.getText()))
      if not url then
        toast("No valid link found. Paste a stream link.")
        return
      end
      local name = cleanName(tostring(nameBox.getText()))
      if name == "" then name = "My Channel " .. (#myChannels + 1) end
      for _, c in ipairs(myChannels) do
        if c.url == url then
          toast("This link is already in your list: " .. c.name)
          return
        end
      end
      myChannels[#myChannels + 1] = {name = name, url = url}
      saveMy()
      refreshMyCat()
      -- ڈائلاگ بند کر دیں
      pcall(function() dlg.dismiss() end)
      toast("Added: " .. name)
      -- سیدھا کسٹم چینلز کی لسٹ کھول دیں
      showChannels(myCat, function() showCategories() end)
    end)
  }))
end

local function removeCustomChannelByName(name, url)
  for i, c in ipairs(myChannels) do
    if c.url == url or (c.name == name and c.url == url) then
      table.remove(myChannels, i)
      saveMy()
      refreshMyCat()
      toast("Removed: " .. name)
      return true
    end
  end
  return false
end

local function showCustomChannelActions(idx)
  local ch = myCat.channels[idx]
  if not ch then return end
  local items = {"Add to Favourite / List...", "Delete from \"" .. myCat.name .. "\"", "Rename"}
  local dlg
  dlg = makeListDialog(ch.name, items, function(pos)
    dlg.dismiss()
    if pos == 1 then
      chooseListAndAdd(ch)
    elseif pos == 3 then
      local input = EditText(ctx)
      input.setSingleLine(true)
      input.setText(ch.name)
      local b = AlertDialog.Builder(ctx)
      b.setTitle("Rename channel")
      b.setView(input)
      b.setPositiveButton("Save", proxy("android.content.DialogInterface$OnClickListener", {
        onClick = guard(function(d, w)
          local newName = cleanName(tostring(input.getText()))
          if newName == "" then
            toast("Please type a name")
            return
          end
          for _, c in ipairs(myChannels) do
            if c.url == ch.url then c.name = newName end
          end
          saveMy()
          refreshMyCat()
          toast("Renamed to: " .. newName)
          showChannels(myCat, function() showCategories() end)
        end)
      }))
      b.setNegativeButton("Cancel", nil)
      showOverlay(b.create())
    elseif pos == 2 then
      confirmDialog("Remove \"" .. ch.name .. "\" from My Channels?", function()
        removeCustomChannelByName(ch.name, ch.url)
        showChannels(myCat, function() showCategories() end)
      end)
    end
  end, nil)
  showOverlay(dlg)
end

function showCustomNowPlaying(ch)
  closeDialog()
  refreshCurrent = function() showCustomNowPlaying(ch) end
  local items, acts = {}, {}
  local function add(label, fn)
    items[#items + 1] = label
    acts[#acts + 1] = fn
  end
  local dlg = nil
  local function moveTo(nch)
    ch = nch
    playCustomChannel(nch)
    if dlg then pcall(function() dlg.setTitle("Now playing: " .. nch.name) end) end
  end
  add("Previous channel", function()
    local n = #myCat.channels
    if n == 0 then return end
    local cur = 1
    for i, c in ipairs(myCat.channels) do
      if c.url == ch.url then cur = i break end
    end
    local idx = cur - 1
    if idx < 1 then idx = n end
    local nch = myCat.channels[idx]
    if nch then moveTo(nch) end
  end)
  add("Stop", function()
    stopPlayer()
    toast("Radio stopped")
    showChannels(myCat, function() showCategories() end)
  end)
  add("Next channel", function()
    local n = #myCat.channels
    if n == 0 then return end
    local cur = 1
    for i, c in ipairs(myCat.channels) do
      if c.url == ch.url then cur = i break end
    end
    local idx = cur + 1
    if idx > n then idx = 1 end
    local nch = myCat.channels[idx]
    if nch then moveTo(nch) end
  end)
  add("Volume up", function() changeVolume(AudioManager.ADJUST_RAISE) end)
  add("Volume down", function() changeVolume(AudioManager.ADJUST_LOWER) end)
  add("Play again", function()
    playCustomChannel(ch)
  end)
  add("Add to Favourite / List...", function() chooseListAndAdd(ch) end)
  add("Remove from My Channels", function()
    stopPlayer()
    confirmDialog("Remove \"" .. ch.name .. "\" from My Channels?", function()
      removeCustomChannelByName(ch.name, ch.url)
      showChannels(myCat, function() showCategories() end)
    end)
  end)
  add("Back to My Channels", function()
    showChannels(myCat, function() showCategories() end)
  end)
  dlg = makeListDialog("Now playing: " .. ch.name, items,
    function(pos)
      local f = acts[pos]
      if f then f() end
    end,
    function() showChannels(myCat, function() showCategories() end) end)
  showDialog(dlg)
end

function chooseListAndAdd(ch)
  if not ch then return end
  local items = {"Favourite", "Pakistan Radio (" .. #pakRadioCat.channels .. ")"}
  for _, l in ipairs(userLists) do
    items[#items + 1] = l.name .. " (" .. #l.channels .. ")"
  end
  items[#items + 1] = "+ Create new list"
  local dlg
  dlg = makeListDialog("Add to", items, function(pos)
    dlg.dismiss()
    if pos == 1 then
      addFav(ch)
    elseif pos == 2 then
      addToList(pakRadioCat, ch)
    elseif pos == #items then
      askListName("", function(name)
        local l = createList(name)
        addToList(l, ch)
      end)
    else
      addToList(userLists[pos - 2], ch)
    end
  end, nil)
  showOverlay(dlg)
end

local function isRemovable(cat)
  return cat == favCat or cat == pakRadioCat or cat == myCat or (cat and cat.isUserList == true)
end

local function removeFromCat(cat, ch)
  if cat == favCat then
    removeFav(ch)
  elseif cat == pakRadioCat then
    for i, f in ipairs(pakRadioCat.channels) do
      if f.url == ch.url then
        table.remove(pakRadioCat.channels, i)
        savePakRadio()
        toast("Removed: " .. ch.name)
        return
      end
    end
  elseif cat == myCat then
    removeCustomChannelByName(ch.name, ch.url)
  elseif cat and cat.isUserList then
    for i, f in ipairs(cat.channels) do
      if f.url == ch.url then
        table.remove(cat.channels, i)
        saveLists()
        toast("Removed: " .. ch.name)
        return
      end
    end
  end
end

local showChannelActions
showChannelActions = function(cat, pos, restoreFn)
  local ch = cat.channels[pos]
  if not ch then return end
  local items = {
    "Add to Favourite / List...",
    "Delete from \"" .. cat.name .. "\"",
  }
  local dlg
  dlg = makeListDialog(ch.name, items, function(p)
    dlg.dismiss()
    if p == 1 then
      chooseListAndAdd(ch)
    elseif p == 2 then
      removeFromCat(cat, ch)
      restoreFn()
    end
  end, nil)
  showOverlay(dlg)
end

showNowPlaying = function()
  closeDialog()
  refreshCurrent = showNowPlaying
  local function curCh() return currentCat and currentCat.channels[currentIdx] end
  local items, acts = {}, {}
  local dlg = nil
  local function add(label, fn)
    items[#items + 1] = label
    acts[#acts + 1] = fn
  end
  -- Change channel without rebuilding the dialog, so your focus stays on the button you pressed.
  local function moveBy(delta)
    step(delta)
    local c = curCh()
    if dlg and c then pcall(function() dlg.setTitle("Now playing: " .. c.name) end) end
  end
  add("Previous channel", function() moveBy(-1) end)
  add("Stop", function()
    stopPlayer()
    toast("Radio stopped")
    showChannels(currentCat, currentBack)
  end)
  add("Next channel", function() moveBy(1) end)
  add("Volume up", function() changeVolume(AudioManager.ADJUST_RAISE) end)
  add("Volume down", function() changeVolume(AudioManager.ADJUST_LOWER) end)
  add("Play again", function() playChannel(currentCat, currentIdx) end)
  add("Add to Favourite / List...", function() chooseListAndAdd(curCh()) end)
  if isRemovable(currentCat) then
    add("Remove from this list", function()
      removeFromCat(currentCat, curCh())
      showChannels(currentCat, currentBack)
    end)
  end
  add("Back to channel list", function() showChannels(currentCat, currentBack) end)
  local ch0 = curCh()
  dlg = makeListDialog("Now playing: " .. (ch0 and ch0.name or ""), items,
    function(pos)
      local f = acts[pos]
      if f then f() end
    end,
    function() showChannels(currentCat, currentBack) end)
  showDialog(dlg)
end

local function goBackFromSearch()
  local bfn = searchBackFn
  searchBackFn = nil
  addTargetCat = nil
  if bfn then bfn() else showCategories() end
end

local function openAddSearch(targetCat, restoreFn)
  addTargetCat = targetCat
  searchBackFn = function()
    addTargetCat = nil
    searchBackFn = nil
    restoreFn()
  end
  askSearch()
end

showChannels = function(cat, backFn)
  closeDialog()
  local removable = isRemovable(cat)
  local isResults = cat and cat.isResults == true
  local isMyCatView = cat == myCat
  if #cat.channels == 0 and not removable and not isResults then
    toast("No channels in this category yet")
    showCategories()
    return
  end
  currentBack = backFn or function() showCategories() end
  refreshCurrent = function() showChannels(cat, backFn) end
  local names = {}
  for i, ch in ipairs(cat.channels) do names[#names + 1] = ch.name end
  local title = cat.name
  if isResults then
    if addTargetCat then
      title = title .. "  [Tap: Play, Long press: Add to " .. addTargetCat.name .. "]"
    else
      title = title .. "  [long press to add to a list]"
    end
    local dlg = makeListDialog(title, names, function(pos)
      playChannel(cat, pos)
      showNowPlaying()
    end, currentBack, function(pos)
      local ch = cat.channels[pos]
      if not ch then return end
      if addTargetCat then
        addToList(addTargetCat, ch)
      else
        chooseListAndAdd(ch)
      end
    end)
    showDialog(dlg)
    return
  end
  if isMyCatView then
    title = title .. "  (" .. #cat.channels .. " channels, long press for options)"
    local topButtons = {
      {
        text = "+ Add custom channel",
        onClick = function()
          askAddCustomChannel()
        end
      }
    }
    local dlg = makeListDialogWithTopButtons(title, topButtons, names, function(pos)
      local ch = cat.channels[pos]
      if not ch then return end
      playCustomChannel(ch)
      showCustomNowPlaying(ch)
    end, currentBack, function(pos)
      showCustomChannelActions(pos)
    end)
    showDialog(dlg)
    return
  end
  if removable then
    title = title .. "  (long press for options)"
    local topButtons = {
      {
        text = "Add more channels (search)",
        onClick = function()
          openAddSearch(cat, function() showChannels(cat, backFn) end)
        end
      }
    }
    local dlg = makeListDialogWithTopButtons(title, topButtons, names, function(pos)
      playChannel(cat, pos)
      showNowPlaying()
    end, currentBack, function(pos)
      showChannelActions(cat, pos, function() showChannels(cat, backFn) end)
    end)
    showDialog(dlg)
    return
  end
  title = title .. "  (long press to add to a list)"
  local dlg = makeListDialog(title, names, function(pos)
    playChannel(cat, pos)
    showNowPlaying()
  end, currentBack, function(pos)
    local ch = cat.channels[pos]
    if not ch then return end
    chooseListAndAdd(ch)
  end)
  showDialog(dlg)
end

local function showListActions(i)
  local list = userLists[i]
  if not list then return end
  local items = {"Open list", "Rename list", "Delete list"}
  local dlg
  dlg = makeListDialog(list.name, items, function(pos)
    dlg.dismiss()
    if pos == 1 then
      showChannels({name = list.name, channels = list.channels, isUserList = true},
        function() showLists() end)
    elseif pos == 2 then
      askListName(list.name, function(name)
        renameList(list, name)
        showLists()
      end)
    else
      confirmDialog("Delete the list \"" .. list.name .. "\"?", function()
        deleteList(i)
        toast("List deleted")
        showLists()
      end)
    end
  end, nil)
  showOverlay(dlg)
end

showLists = function()
  closeDialog()
  refreshCurrent = showLists
  local items = {"+ Create new list"}
  for _, l in ipairs(userLists) do
    items[#items + 1] = l.name .. " (" .. #l.channels .. " channels)"
  end
  local dlg = makeListDialog("My Lists", items, function(pos)
    if pos == 1 then
      askListName("", function(name)
        local l = createList(name)
        toast("List created: " .. name)
        showChannels({name = l.name, channels = l.channels, isUserList = true},
          function() showLists() end)
      end)
    else
      showListActions(pos - 1)
    end
  end, function() showCategories() end)
  showDialog(dlg)
end

local function countrySearchScore(country, query)
  local q = tostring(query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if q == "" then return 1 end
  local name = country:lower()
  local codes = countryCodes[country] or ""
  if name == q then return 1000 end
  for code in codes:gmatch("[^,]+") do
    if code:lower() == q then return 1000 end
  end
  if name:sub(1, #q) == q then return 800 end
  for code in codes:gmatch("[^,]+") do
    if code:lower():sub(1, #q) == q then return 800 end
  end
  if name:find(q, 1, true) then return 500 end
  return 0
end

local function showCountrySearch(onSelected)
  local root = LinearLayout(ctx)
  root.setOrientation(LinearLayout.VERTICAL)
  root.setPadding(20, 10, 20, 10)
  local input = EditText(ctx)
  input.setSingleLine(true)
  input.setHint("Country name or code")
  root.addView(input, LinearLayout.LayoutParams(-1, -2))
  local listView = ListView(ctx)
  root.addView(listView, LinearLayout.LayoutParams(-1, 0, 1))
  local b = AlertDialog.Builder(ctx)
  b.setTitle("Search Country")
  b.setView(root)
  b.setNegativeButton("Back", nil)
  local dlg = b.create()
  local resultCountries = {}
  local function updateList()
    local q = tostring(input.getText())
    local results = {}
    resultCountries = {}
    for _, country in ipairs(countryNames) do
      local score = countrySearchScore(country, q)
      if score > 0 then
        results[#results + 1] = {country = country, score = score}
      end
    end
    table.sort(results, function(a, b)
      if a.score ~= b.score then return a.score > b.score end
      return a.country:lower() < b.country:lower()
    end)
    local array = ArrayList()
    for _, item in ipairs(results) do
      resultCountries[#resultCountries + 1] = item.country
      array.add(item.country .. " (" .. (countryCodes[item.country] or "") .. ")")
    end
    listView.setAdapter(ArrayAdapter(ctx, android.R.layout.simple_list_item_1, array))
  end
  updateList()
  input.addTextChangedListener(proxy("android.text.TextWatcher", {
    beforeTextChanged = function(s, start, count, after) end,
    onTextChanged = guard(function(s, start, before, count) updateList() end),
    afterTextChanged = function(s) end,
  }))
  listView.setOnItemClickListener(proxy("android.widget.AdapterView$OnItemClickListener", {
    onItemClick = guard(function(parent, view, position, id)
      local country = resultCountries[position + 1]
      if country then
        dlg.dismiss()
        if onSelected then onSelected(country) end
      end
    end)
  }))
  showOverlay(dlg)
end

local function openWhatsAppFeedback()
  local msg = "Hello " .. DEVELOPER_NAME .. "! I am using your World Radio extension. My feedback: "
  local encoded = tostring(URLEncoder.encode(msg, "UTF-8"))
  local url = "https://wa.me/" .. WHATSAPP_INTL .. "?text=" .. encoded
  local opened = false
  pcall(function()
    local intent = luajava.newInstance("android.content.Intent", "android.intent.action.VIEW")
    intent.setData(luajava.bindClass("android.net.Uri").parse(url))
    intent.setPackage("com.whatsapp")
    intent.addFlags(0x10000000)
    if activity then activity.startActivity(intent) else ctx.startActivity(intent) end
    opened = true
  end)
  if not opened then
    pcall(function()
      local intent = luajava.newInstance("android.content.Intent", "android.intent.action.VIEW")
      intent.setData(luajava.bindClass("android.net.Uri").parse(url))
      intent.addFlags(0x10000000)
      if activity then activity.startActivity(intent) else ctx.startActivity(intent) end
      opened = true
    end)
  end
  if not opened then
    toast("WhatsApp is not installed on this device")
    return
  end
  pcall(function()
    local h = luajava.newInstance("android.os.Handler", Looper.getMainLooper())
    h.postDelayed(proxy("java.lang.Runnable", {
      run = function()
        pcall(function()
          if activity then activity.finish() end
        end)
      end
    }), 600)
  end)
end

showAbout = function()
  closeDialog()
  refreshCurrent = showAbout
  local scroll = ScrollView(ctx)
  local content = LinearLayout(ctx)
  content.setOrientation(LinearLayout.VERTICAL)
  content.setPadding(30, 20, 30, 20)
  scroll.addView(content, ScrollView.LayoutParams(-1, -2))
  local function addText(text, size, bold, color)
    local tv = TextView(ctx)
    tv.setText(text)
    tv.setTextSize(size or 14)
    if bold then
      pcall(function()
        tv.setTypeface(nil, luajava.bindClass("android.graphics.Typeface").BOLD)
      end)
    end
    if color then pcall(function() tv.setTextColor(color) end) end
    local lp = LinearLayout.LayoutParams(-1, -2)
    lp.topMargin = 6
    lp.bottomMargin = 6
    content.addView(tv, lp)
  end
  addText("World Radio", 24, true)
  addText("Version " .. CURRENT_VERSION, 12)
  addText("Developer " .. DEVELOPER_NAME, 14, true)
  addText("", 4)
  addText("About This Extension", 17, true)
  addText("World Radio brings thousands of live radio stations from every corner of the world directly to your Android device.", 13)
  addText("Key Features", 16, true)
  addText("Pakistan Radio - All official Radio Pakistan stations in one place.", 13)
  addText("Smart Search - Search by language, city, radio frequency, channel name, or nearby stations using GPS.", 13)
  addText("Country Search - Browse every radio station of any country.", 13)
  addText("Favourite and Custom Lists - Save favourites and create unlimited custom lists.", 13)
  addText("My Custom Channels - Add your own stream links.", 13)
  addText("Two Data Sources - Radio Garden and Radio Browser together.", 13)
  addText("Background Play - Keeps playing after you leave.", 13)
  addText("Auto Cache Clean - Cache is cleared every time you close the extension.", 13)
  addText("200+ Countries and Thousands of Stations.", 13)
  addText("Feedback and Support", 16, true)
  addText("Contact the developer on WhatsApp:", 13)
  addText("Developer: " .. DEVELOPER_NAME, 14, true)
  addText("WhatsApp: " .. WHATSAPP_NUMBER, 14, true)
  addText("", 6)
  local upBtn = Button(ctx)
  upBtn.setText("Check for updates")
  content.addView(upBtn, LinearLayout.LayoutParams(-1, -2))
  upBtn.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      checkForUpdate(true)
    end)
  }))
  local waBtn = Button(ctx)
  waBtn.setText("Send Feedback on WhatsApp")
  content.addView(waBtn, LinearLayout.LayoutParams(-1, -2))
  waBtn.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      openWhatsAppFeedback()
    end)
  }))
  local b = AlertDialog.Builder(ctx)
  b.setTitle("About")
  b.setView(scroll)
  b.setNegativeButton("Back", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function() showSettings() end)
  }))
  showDialog(b.create())
end

showSettings = function()
  closeDialog()
  refreshCurrent = showSettings
  local root = ScrollView(ctx)
  local content = LinearLayout(ctx)
  content.setOrientation(LinearLayout.VERTICAL)
  content.setPadding(20, 10, 20, 10)
  root.addView(content, ScrollView.LayoutParams(-1, -2))
  local function addLabel(text)
    local tv = TextView(ctx)
    tv.setText(text)
    content.addView(tv, LinearLayout.LayoutParams(-1, -2))
  end
  local function addCheck(label, info, value, onChange)
    local cb = CheckBox(ctx)
    cb.setText(label)
    cb.setChecked(value)
    content.addView(cb, LinearLayout.LayoutParams(-1, -2))
    if info then addLabel(info) end
    cb.setOnCheckedChangeListener(proxy("android.widget.CompoundButton$OnCheckedChangeListener", {
      onCheckedChanged = guard(function(button, checked) onChange(checked) end)
    }))
  end
  local function addSpinner(label, items, selected, onSelect)
    addLabel(label)
    local sp = Spinner(ctx)
    local list = ArrayList()
    for _, it in ipairs(items) do list.add(it) end
    local adapter = ArrayAdapter(ctx, android.R.layout.simple_spinner_item, list)
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    sp.setAdapter(adapter)
    sp.setSelection(selected)
    content.addView(sp, LinearLayout.LayoutParams(-1, -2))
    local initial = selected
    local first = true
    sp.setOnItemSelectedListener(proxy("android.widget.AdapterView$OnItemSelectedListener", {
      onItemSelected = guard(function(parent, view, position, id)
        if first then
          first = false
          if position == initial then return end
        end
        onSelect(position)
      end),
      onNothingSelected = function() end,
    }))
  end
  local function addButton(label, onClick)
    local btn = Button(ctx)
    btn.setText(label)
    content.addView(btn, LinearLayout.LayoutParams(-1, -2))
    btn.setOnClickListener(proxy("android.view.View$OnClickListener", {
      onClick = guard(function() onClick() end)
    }))
  end
  addCheck("Background play",
    "Keep the radio playing after you leave the extension.",
    settings.background, function(v) setSetting("background", v) end)
  addCheck("Also search Radio Browser",
    "Adds many more stations. Turn off to use Radio Garden only.",
    settings.rb, function(v) setSetting("rb", v) end)
  addCheck("Use my location in results",
    "Show nearby stations first in every search filter.",
    settings.useLocation, function(v)
      setSetting("useLocation", v)
      _locState.cached = nil
      if v then pcall(function() updateLocationCountry() end) end
    end)
  local homeItems = {"Auto-detect from my location (" .. deviceCountry() .. ")"}
  local homePos = 0
  for i, c in ipairs(countryNames) do
    homeItems[#homeItems + 1] = c
    if settings.home ~= "auto" and c == settings.home then homePos = i end
  end
  addSpinner("Home country", homeItems, homePos, function(pos)
    if pos == 0 then
      setSetting("home", "auto")
    elseif countryNames[pos] then
      setSetting("home", countryNames[pos])
    end
  end)
  local capValues = {40, 80, 150}
  local capPos = (settings.countryCap == 40 and 0) or (settings.countryCap == 150 and 2) or 1
  addSpinner("Country search: minimum cities to load",
    {"At least 40 cities", "At least 80 cities", "At least 150 cities"}, capPos, function(pos)
      setSetting("countryCap", capValues[pos + 1] or 80)
    end)
  addCheck("Home country channels first", nil, settings.homeFirst,
    function(v) setSetting("homeFirst", v) end)
  addCheck("Country tag in results", nil, settings.tags,
    function(v) setSetting("tags", v) end)
  addLabel("Auto Clean: Cache and cities data are refreshed every time you close the extension.")
  addButton("About and Feedback", function()
    showAbout()
  end)
  addButton("Reset all settings", function()
    confirmDialog("Reset all settings to default? Your lists and channels are not deleted.", function()
      resetSettings()
      toast("Settings reset")
      showSettings()
    end)
  end)
  local b = AlertDialog.Builder(ctx)
  b.setTitle("Settings")
  b.setView(root)
  b.setNegativeButton("Back", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function() showCategories() end)
  }))
  showDialog(b.create())
end

askSearch = function()
  closeDialog()
  pcall(function() updateLocationCountry() end)
  local root = LinearLayout(ctx)
  root.setOrientation(LinearLayout.VERTICAL)
  root.setPadding(20, 10, 20, 10)
  local filterLabels = {
    "Auto (Smart Search)",
    "Search by Language",
    "Search by City",
    "Search by Radio Frequency",
    "Search Nearby Stations (GPS)",
    "Search by Channel Name",
  }
  local filterTypes = {"auto", "language", "city", "frequency", "nearby", "name"}
  local filterHints = {
    "Try any name, city, language or frequency",
    "Type a language, e.g. urdu, english, arabic",
    "Type a city name, e.g. Lahore, Karachi, Dubai",
    "Type a frequency, e.g. 101 or FM 101 or 101.5",
    "Uses your GPS location (no typing needed)",
    "Type a channel name, e.g. Suno FM, Mast FM",
  }
  local input = EditText(ctx)
  input.setSingleLine(true)
  if addTargetCat then
    input.setHint("Search - Tap: Play, Long press: Add to " .. addTargetCat.name)
  else
    input.setHint(filterHints[1])
  end
  root.addView(input, LinearLayout.LayoutParams(-1, -2))
  local filterLabel = TextView(ctx)
  filterLabel.setText("Filter:")
  filterLabel.setTextSize(13)
  local flp = LinearLayout.LayoutParams(-1, -2)
  flp.topMargin = 10
  root.addView(filterLabel, flp)
  local filterSpinner = Spinner(ctx)
  local filterList = ArrayList()
  for _, s in ipairs(filterLabels) do filterList.add(s) end
  local filterAdapter = ArrayAdapter(ctx, android.R.layout.simple_spinner_item, filterList)
  filterAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
  filterSpinner.setAdapter(filterAdapter)
  filterSpinner.setSelection(0)
  root.addView(filterSpinner, LinearLayout.LayoutParams(-1, -2))
  filterSpinner.setOnItemSelectedListener(proxy("android.widget.AdapterView$OnItemSelectedListener", {
    onItemSelected = guard(function(parent, view, position, id)
      local t = filterTypes[position + 1]
      if addTargetCat then
        if t == "nearby" then
          input.setHint("Tap Search for nearby stations to add to " .. addTargetCat.name)
        else
          input.setHint("Search - Tap: Play, Long press: Add to " .. addTargetCat.name)
        end
      else
        input.setHint(filterHints[position + 1] or "")
      end
    end),
    onNothingSelected = function() end,
  }))
  local buttonRow = LinearLayout(ctx)
  buttonRow.setOrientation(LinearLayout.HORIZONTAL)
  local searchButton = Button(ctx)
  searchButton.setText("Search")
  local countrySearchButton = Button(ctx)
  countrySearchButton.setText("Search Country")
  local p1 = LinearLayout.LayoutParams(0, -2)
  p1.weight = 1
  local p2 = LinearLayout.LayoutParams(0, -2)
  p2.weight = 1
  buttonRow.addView(searchButton, p1)
  buttonRow.addView(countrySearchButton, p2)
  root.addView(buttonRow, LinearLayout.LayoutParams(-1, -2))
  local spinner = Spinner(ctx)
  local spinnerNames = {"Select country"}
  for _, name in ipairs(countryNames) do spinnerNames[#spinnerNames + 1] = name end
  local spinnerList = ArrayList()
  for _, n in ipairs(spinnerNames) do spinnerList.add(n) end
  local spinnerAdapter = ArrayAdapter(ctx, android.R.layout.simple_spinner_item, spinnerList)
  spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
  spinner.setAdapter(spinnerAdapter)
  spinner.setSelection(0)
  root.addView(spinner, LinearLayout.LayoutParams(-1, -2))
  local countryHint = TextView(ctx)
  countryHint.setText("Country: No country selected")
  root.addView(countryHint, LinearLayout.LayoutParams(-1, -2))
  local b = AlertDialog.Builder(ctx)
  b.setTitle("World Radio Developer " .. DEVELOPER_NAME)
  b.setView(root)
  b.setNegativeButton("Back", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function() goBackFromSearch() end)
  }))
  local dlg = b.create()
  local ignoreNextSpinnerEvent = false
  countrySearchButton.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      showCountrySearch(function(country)
        countryHint.setText("Country selected: " .. country)
        pcall(function() dlg.dismiss() end)
        smartSearch(country, goBackFromSearch, country)
      end)
    end)
  }))
  searchButton.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      local q = tostring(input.getText())
      q = q:gsub("^%s+", ""):gsub("%s+$", "")
      local filterPos = filterSpinner.getSelectedItemPosition()
      local ftype = filterTypes[filterPos + 1] or "auto"
      if ftype == "nearby" then
        pcall(function() dlg.dismiss() end)
        nearbySearch(goBackFromSearch)
        return
      end
      if q == "" then
        toast("Please type something first")
        return
      end
      pcall(function() dlg.dismiss() end)
      if ftype == "auto" then
        smartSearch(q, goBackFromSearch)
      else
        smartSearch(q, goBackFromSearch, nil, ftype)
      end
    end)
  }))
  spinner.setOnItemSelectedListener(proxy("android.widget.AdapterView$OnItemSelectedListener", {
    onItemSelected = guard(function(parent, view, position, id)
      if ignoreNextSpinnerEvent then
        ignoreNextSpinnerEvent = false
        return
      end
      if position == 0 then
        countryHint.setText("Country: No country selected")
        return
      end
      local country = tostring(spinnerNames[position + 1])
      countryHint.setText("Country selected: " .. country)
      pcall(function() dlg.dismiss() end)
      smartSearch(country, goBackFromSearch, country)
    end),
    onNothingSelected = function() end,
  }))
  showDialog(dlg)
end

showCategories = function()
  closeDialog()
  refreshCurrent = showCategories
  local scroll = ScrollView(ctx)
  local root = LinearLayout(ctx)
  root.setOrientation(LinearLayout.VERTICAL)
  root.setPadding(12, 12, 12, 12)
  scroll.addView(root, ScrollView.LayoutParams(-1, -2))
  local function makeBtn(label, weight, onClick, onLongClick)
    local btn = Button(ctx)
    btn.setText(label)
    local lp
    if weight then
      lp = LinearLayout.LayoutParams(0, -2)
      lp.weight = weight
      lp.leftMargin = 6
      lp.rightMargin = 6
      lp.topMargin = 4
      lp.bottomMargin = 4
    else
      lp = LinearLayout.LayoutParams(-1, -2)
      lp.leftMargin = 6
      lp.rightMargin = 6
      lp.topMargin = 4
      lp.bottomMargin = 4
    end
    root.addView(btn, lp)
    btn.setOnClickListener(proxy("android.view.View$OnClickListener", {
      onClick = guard(function() onClick() end)
    }))
    if onLongClick then
      btn.setOnLongClickListener(proxy("android.view.View$OnLongClickListener", {
        onLongClick = function(v)
          guard(function() onLongClick() end)()
          return true
        end
      }))
    end
    return btn
  end
  makeBtn("Search radio channels", nil, function()
    addTargetCat = nil
    searchBackFn = nil
    askSearch()
  end)
  makeBtn("My Custom Channels (" .. #myChannels .. ")", nil, function()
    addTargetCat = nil
    searchBackFn = nil
    showChannels(myCat, function() showCategories() end)
  end)
  makeBtn("+ Add Custom Channel", nil, function()
    addTargetCat = nil
    searchBackFn = nil
    askAddCustomChannel()
  end)
  local row1 = LinearLayout(ctx)
  row1.setOrientation(LinearLayout.HORIZONTAL)
  root.addView(row1, LinearLayout.LayoutParams(-1, -2))
  local favBtn = Button(ctx)
  favBtn.setText("Favourite (" .. #favCat.channels .. ")")
  local pakBtn = Button(ctx)
  pakBtn.setText("Pakistan Radio (" .. #pakRadioCat.channels .. ")")
  local lp1 = LinearLayout.LayoutParams(0, -2)
  lp1.weight = 1
  local lp2 = LinearLayout.LayoutParams(0, -2)
  lp2.weight = 1
  lp2.leftMargin = 8
  row1.addView(favBtn, lp1)
  row1.addView(pakBtn, lp2)
  favBtn.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      addTargetCat = nil
      searchBackFn = nil
      showChannels(favCat, function() showCategories() end)
    end)
  }))
  pakBtn.setOnClickListener(proxy("android.view.View$OnClickListener", {
    onClick = guard(function()
      addTargetCat = nil
      searchBackFn = nil
      showChannels(pakRadioCat, function() showCategories() end)
    end)
  }))
  local i = 1
  while i <= #userLists do
    local row = LinearLayout(ctx)
    row.setOrientation(LinearLayout.HORIZONTAL)
    root.addView(row, LinearLayout.LayoutParams(-1, -2))
    local l1 = userLists[i]
    local b1 = Button(ctx)
    b1.setText(l1.name .. " (" .. #l1.channels .. ")")
    local pA = LinearLayout.LayoutParams(0, -2)
    pA.weight = 1
    local pB = LinearLayout.LayoutParams(0, -2)
    pB.weight = 1
    pB.leftMargin = 8
    row.addView(b1, pA)
    local l2 = userLists[i + 1]
    local b2 = nil
    if l2 then
      b2 = Button(ctx)
      b2.setText(l2.name .. " (" .. #l2.channels .. ")")
      row.addView(b2, pB)
    else
      local spacer = View(ctx)
      row.addView(spacer, pB)
    end
    b1.setOnClickListener(proxy("android.view.View$OnClickListener", {
      onClick = guard(function()
        addTargetCat = nil
        searchBackFn = nil
        showChannels({name = l1.name, channels = l1.channels, isUserList = true},
          function() showCategories() end)
      end)
    }))
    b1.setOnLongClickListener(proxy("android.view.View$OnLongClickListener", {
      onLongClick = function(v)
        guard(function() showUserListActions(l1) end)()
        return true
      end
    }))
    if b2 and l2 then
      b2.setOnClickListener(proxy("android.view.View$OnClickListener", {
        onClick = guard(function()
          addTargetCat = nil
          searchBackFn = nil
          showChannels({name = l2.name, channels = l2.channels, isUserList = true},
            function() showCategories() end)
        end)
      }))
      b2.setOnLongClickListener(proxy("android.view.View$OnLongClickListener", {
        onLongClick = function(v)
          guard(function() showUserListActions(l2) end)()
          return true
        end
      }))
    end
    i = i + 2
  end
  makeBtn("+ Create New List", nil, function()
    local input = EditText(ctx)
    input.setSingleLine(true)
    input.setHint("Type list name here...")
    local b = AlertDialog.Builder(ctx)
    b.setTitle("Create New List")
    b.setView(input)
    b.setPositiveButton("Create", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w)
        local name = cleanName(tostring(input.getText()))
        if name == "" then
          toast("Please type a list name")
          return
        end
        createList(name)
        toast("List created: " .. name)
        showCategories()
      end)
    }))
    b.setNegativeButton("Cancel", nil)
    showOverlay(b.create())
  end)
  makeBtn("Settings", nil, function()
    showSettings()
  end)
  local outer = AlertDialog.Builder(ctx)
  outer.setTitle("World Radio Developer " .. DEVELOPER_NAME)
  outer.setView(scroll)
  if playerActive() then
    outer.setPositiveButton("Stop", proxy("android.content.DialogInterface$OnClickListener", {
      onClick = guard(function(d, w)
        stopPlayer()
        toast("Radio stopped")
        if refreshCurrent then refreshCurrent() end
      end)
    }))
  end
  outer.setNegativeButton("Close", nil)
  showDialog(outer.create())
end

function showUserListActions(list)
  local items = {"Open list", "Rename list", "Delete list"}
  local dlg
  dlg = makeListDialog(list.name, items, function(pos)
    dlg.dismiss()
    if pos == 1 then
      showChannels({name = list.name, channels = list.channels, isUserList = true},
        function() showCategories() end)
    elseif pos == 2 then
      askListName(list.name, function(name)
        renameList(list, name)
        showCategories()
      end)
    else
      confirmDialog("Delete the list \"" .. list.name .. "\"?", function()
        for idx, l in ipairs(userLists) do
          if l == list then
            deleteList(idx)
            break
          end
        end
        toast("List deleted")
        showCategories()
      end)
    end
  end, nil)
  showOverlay(dlg)
end

-- ===================== Auto update =====================
function updTrim(x)
  return (tostring(x or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- returns 1 if a > b, -1 if a < b, 0 if equal (e.g. "1.10" > "1.9")
function updCompare(a, b)
  local pa, pb = {}, {}
  for n in tostring(a):gmatch("%d+") do pa[#pa + 1] = tonumber(n) end
  for n in tostring(b):gmatch("%d+") do pb[#pb + 1] = tonumber(n) end
  for i = 1, math.max(#pa, #pb) do
    local x, y = pa[i] or 0, pb[i] or 0
    if x > y then return 1 end
    if x < y then return -1 end
  end
  return 0
end

function updFetch(urlStr)
  local sep = urlStr:find("?", 1, true) and "&" or "?"
  local u = luajava.newInstance("java.net.URL", urlStr .. sep .. "t=" .. tostring(os.time()))
  local conn = u.openConnection()
  conn.setUseCaches(false)
  conn.setConnectTimeout(10000)
  conn.setReadTimeout(30000)
  conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Linux; Android 12)")
  conn.setRequestProperty("Cache-Control", "no-cache")
  local code = conn.getResponseCode()
  if code ~= 200 then
    pcall(function() conn.disconnect() end)
    error("server answered with HTTP " .. tostring(code))
  end
  local text = readText(conn, 6000000)
  pcall(function() conn.disconnect() end)
  return text
end

function updPluginPath()
  local cands = {}
  pcall(function()
    local src = debug.getinfo(updPluginPath, "S").source
    if src and src:sub(1, 1) == "@" then cands[#cands + 1] = src:sub(2) end
  end)
  cands[#cands + 1] = UPDATER.path
  for _, p in ipairs(cands) do
    local f = io.open(p, "r")
    if f then
      f:close()
      return p
    end
  end
  return nil
end

function updInstall(code, newVersion)
  -- 1) the new file must be valid Lua, otherwise nothing is touched
  local fn = nil
  local okLoad = pcall(function() fn = (loadstring or load)(code) end)
  if not okLoad or not fn then
    showMessage("Update failed", "The downloaded file is damaged, so nothing was changed. Please try again later.")
    return
  end
  -- 2) make About show exactly the version from version.txt
  code = (code:gsub('CURRENT_VERSION%s*=%s*"[^"]*"', 'CURRENT_VERSION = "' .. newVersion .. '"', 1))
  local path = updPluginPath()
  if not path then
    showMessage("Update failed", "Could not find the extension file on the phone:\n" .. tostring(UPDATER.path))
    return
  end
  local old = nil
  local rf = io.open(path, "rb")
  if rf then old = rf:read("*a") rf:close() end
  if old then
    local bf = io.open(path .. ".bak", "wb")
    if bf then bf:write(old) bf:close() end
  end
  local tmp = path .. ".temp_update"
  local wf = io.open(tmp, "wb")
  if not wf then
    showMessage("Update failed", "Could not write to the extension folder.")
    return
  end
  wf:write(code)
  wf:close()
  pcall(function() os.remove(path) end)
  local okRen = pcall(function() assert(os.rename(tmp, path)) end)
  local check = io.open(path, "rb")
  if not okRen or not check then
    -- put the old version back
    if old then
      local rf2 = io.open(path, "wb")
      if rf2 then rf2:write(old) rf2:close() end
    end
    pcall(function() os.remove(tmp) end)
    showMessage("Update failed", "The file could not be replaced. Your current version is unchanged.")
    return
  end
  check:close()
  local b = AlertDialog.Builder(ctx)
  b.setTitle("Update successful")
  b.setMessage("World Radio is now version " .. newVersion .. ". The extension will reopen.")
  b.setCancelable(false)
  b.setPositiveButton("OK", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function()
      closeDialog()
      post(function()
        local f2, err = loadfile(path)
        if f2 then
          pcall(f2)
        else
          toast("Please close and reopen the extension")
        end
      end, 1200)
    end)
  }))
  showOverlay(b.create())
end

function updShowAvailable(newVersion)
  local b = AlertDialog.Builder(ctx)
  b.setTitle("Update available")
  b.setMessage("A new version (" .. newVersion .. ") is available.\nCurrent version: " .. CURRENT_VERSION ..
    "\n\nDo you want to update now?")
  b.setPositiveButton("Update now", proxy("android.content.DialogInterface$OnClickListener", {
    onClick = guard(function()
      toast("Downloading update...")
      UPDATER.busy = true
      runAsync(function()
        return updFetch(UPDATER.codeUrl)
      end, function(ok, res)
        UPDATER.busy = false
        if not ok or type(res) ~= "string" or updTrim(res) == "" then
          showMessage("Update failed", "Could not download the update: " .. tostring(res))
          return
        end
        updInstall(res, newVersion)
      end)
    end)
  }))
  b.setNegativeButton("Later", nil)
  showOverlay(b.create())
end

function checkForUpdate(manual)
  local U = UPDATER
  if U.busy then
    if manual then toast("An update is already in progress") end
    return
  end
  if U.versionUrl:find("YOUR_", 1, true) or U.codeUrl:find("YOUR_", 1, true) then
    if manual then
      showMessage("Update", "The update links are not set yet. Put your GitHub links in UPDATER at the top of main.lua.")
    end
    return
  end
  U.busy = true
  if manual then toast("Checking for updates...") end
  runAsync(function()
    local v = updTrim(updFetch(U.versionUrl))
    return v:match("%d[%d%.]*")
  end, function(ok, v)
    U.busy = false
    if not ok or not v then
      if manual then
        showMessage("Update check failed", "Could not reach the update server. Please check your internet connection.")
      end
      return
    end
    if updCompare(v, CURRENT_VERSION) > 0 then
      updShowAvailable(v)
    elseif manual then
      showMessage("No update", "You already have the latest version (" .. CURRENT_VERSION .. ").")
    end
  end)
end


pcall(function() updateLocationCountry() end)
showCategories()
post(function() checkForUpdate(false) end, 3000)
