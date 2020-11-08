local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local DJ = Addon.Modules.DungeonJournal
local L = Addon.L

-- Most data taken from AtlasLootClassic_DungeonsAndRaids
DJ.BOSS_LEVEL = 999
DJ.Database = {
    Dungeons = {
        {
            name = "RagefireChasm",
            id = 389,
            min = 10,
            recommended = {13,18},
            lore = "Ragefire Chasm consists of a network of volcanic caverns that lie below the orcs' new capital city of Orgrimmar. Recently, rumors have spread that a cult loyal to the demonic Shadow Council has taken up residence within the Chasm's fiery depths. This cult, known as the Burning Blade, threatens the very sovereignty of Durotar. Many believe that the orc Warchief, Thrall, is aware of the Blade's existence and has chosen not to destroy it in the hopes that its members might lead him straight to the Shadow Council. Either way, the dark powers emanating from Ragefire Chasm could undo all that the orcs have fought to attain.",
            bosses = {
                {
                    name = "Taragaman the Hungerer",
                    id = 11520,
                    displayId = 7970,
                    level = 16,
                    items = {
                        { 14149 }, -- Subterranean Cape
                        { 14148 }, -- Crystalline Cuffs
                        { 14145 }, -- Cursed Felblade
                    }
                },
                {                    
                    name = "Jergosh the Invoker",
                    id = 11518,
                    displayId = 11429,
                    level = 16,
                    items = {
                        { 14150 }, -- Robe of Evocation
                        { 14147 }, -- Cavedweller Bracers
                        { 14151 }, -- Chanting Blade
                    },
                }
            }
        },
        {
            name = "Deadmines",
            id = 36,
            min = 10,
            recommended = {17,24},
            lore = "Once the greatest gold production center in the human lands, the Deadmines were abandoned when the Horde razed Stormwind city during the First War. Now the Defias Brotherhood has taken up residence and turned the dark tunnels into their private sanctum. It is rumored that the thieves have conscripted the clever goblins to help them build something terrible at the bottom of the mines - but what that may be is still uncertain. Rumor has it that the way into the Deadmines lies through the quiet, unassuming village of Moonbrook.",
            bosses = {
                {
                    name = "Rhahk'Zor",
                    imageName = "Stomper Kreeg",
                    id = 644,
                    displayId = 14403,
                    level = 19,
                    items = {
                        { 872 },	-- Rockslicer
                        { 5187 },	-- Rhahk'Zor's Hammer
                    },
                },
                {
                    name = "Miner Johnson",
                    imageName = "Magistrate Barthilas",
                    id = 3586,
                    displayId = 556,
                    level = 19,
                    isRare = true,
                    items = {
                        { 5443 },	-- Gold-plated Buckler
                        { 5444 },	-- Miner's Cape
                    },
                },
                {
                    name = "Sneed",
                    imageName = "Tinkerer Gizlock",
                    id = 643,
                    displayId = 7125,
                    level = 20,
                    items = {
                        { 5194 },	-- Taskmaster Axe
                        { 5195 },	-- Gold-flecked Gloves
                    }
                },
                {
                    name = "Sneed's Shredder",
                    imageName = "Techbot",
                    id = 642,
                    displayId = 1269,
                    level = 20,
                    items = {
                        { 1937 },	-- Buzz Saw
                        { 2169 },	-- Buzzer Blade
                    }
                },
                {
                    name = "Gilnid",
                    imageName = "Pauli Rocketspark",
                    id = 1763,
                    displayId = 7124,
                    level = 20,
                    items = {
                        { 1156 },	-- Lavishly Jeweled Ring
                        { 5199 },	-- Smelting Pants
                    }
                },
                {
                    name = "Mr. Smite",
                    imageName = "Default", -- TODO: replace
                    id = 646,
                    displayId = 2026,
                    level = 20,
                    items = {
                        { 7230 },	-- Smite's Mighty Hammer
                        { 5192 },	-- Thief's Blade
                        { 5196 },	-- Smite's Reaver
                    }
                },
                {
                    name = "Captain Greenskin",
                    imageName = "Default",
                    id = 647,
                    displayId = 7113,
                    level = 20,
                    items = {
                        { 5201 },	-- Emberstone Staff
                        { 10403 },	-- Blackened Defias Belt
                        { 5200 },	-- Impaling Harpoon
                    }
                },
                {
                    name = "Edwin VanCleef",
                    imageName = "Default",
                    id = 639,
                    displayId = 2029,
                    level = 21,
                    items = {
                        { 5193 },	-- Cape of the Brotherhood
                        { 5202 },	-- Corsair's Overshirt
                        { 10399 },	-- Blackened Defias Armor
                        { 5191 },	-- Cruel Barb
                        { 2874 },	-- An Unsent Letter
                    }
                },
                {
                    name = "Cookie",
                    imageName = "Captain Cookie",
                    id = 645,
                    displayId = 1305,
                    level = 20,
                    items = {
                        { 5198 },	-- Cookie's Stirring Rod
                        { 5197 },	-- Cookie's Tenderizer
                        { 8490 },	-- Cat Carrier (Siamese)
                    }
                },
            }
        },
        {
            name = "WailingCaverns",
            id = 43,
            min = 10,
            recommended = {17,24},
            lore = "Recently, a night elf druid named Naralex discovered a network of underground caverns within the heart of the Barrens. Dubbed the 'Wailing Caverns', these natural caves were filled with steam fissures which produced long, mournful wails as they vented. Naralex believed he could use the caverns' underground springs to restore lushness and fertility to the Barrens - but to do so would require siphoning the energies of the fabled Emerald Dream. Once connected to the Dream, however, the druid's vision somehow became a nightmare. Soon the Wailing Caverns began to change - the waters turned foul and the once-docile creatures inside metamorphosed into vicious, deadly predators. It is said that Naralex himself still resides somewhere inside the heart of the labyrinth, trapped beyond the edges of the Emerald Dream. Even his former acolytes have been corrupted by their master's waking nightmare - transformed into the wicked Druids of the Fang.",
            bosses = {
                {
                    name = "Lord Cobrahn",
                    id = 3669,
                    displayId = 4213,
                    level = 20,
                    items = {
                        { 6460 }, -- Cobrahn's Grasp
                        { 10410 }, -- Leggings of the Fang
                        { 6465 }, -- Robe of the Moccasin
                    },
                },
                {                    
                    name = "Lady Anacondra",
                    id = 3671,
                    displayId = 4313,
                    level = 20,
                    items = {
                        { 10412 }, -- Belt of the Fang
                        { 5404 }, -- Serpent's Shoulders
                        { 6446 }, -- Snakeskin Bag
                    },
                },
                {
                    name = "Kresh",
                    id = 3653,
                    displayId = 5126,
                    level = 20,
                    items = {
                        { 13245 }, -- Kresh's Back
                        { 6447 }, -- Worn Turtle Shell Shield
                    },
                },
                {
                    name = "Lord Pythas",
                    id = 3670,
                    displayId = 4214,
                    level = 21,
                    items = {
                        { 6472 }, -- Stinging Viper
                        { 6473 }, -- Armor of the Fang
                    },
                },
                {
                    name = "Skum",
                    id = 3674,
                    displayId = 4203,
                    level = 21,
                    items = {
                        { 6449 }, -- Glowing Lizardscale Cloak
                        { 6448 }, -- Tail Spike
                    },
                },
                {
                    name = "Lord Serpentis",
                    id = 3673,
                    displayId = 4215,
                    level = 21,
                    items = {
                        { 6469 }, -- Venomstrike
                        { 5970 }, -- Serpent Gloves
                        { 10411 }, -- Footpads of the Fang
                        { 6459 }, -- Savage Trodders
                    },
                },
                {
                    name = "Verdan the Everliving",
                    id = 5775,
                    displayId = 4256,
                    level = 21,
                    items = {
                        { 6630 }, -- Seedcloud Buckler
                        { 6631 }, -- Living Root
                        { 6629 }, -- Sporid Cape
                    },
                },
                {
                    name = "Mutanus the Devourer",
                    id = 3654,
                    displayId = 4088,
                    level = 22,
                    items = {
                        { 6461 }, -- Slime-encrusted Pads
                        { 6627 }, -- Mutant Scale Breastplate
                        { 6463 }, -- Deep Fathom Ring
                        { 10441 }, -- Glowing Shard
                    },
                },
                {
                    name = "Deviate Faerie Dragon",
                    id = 5912,
                    displayId = 1267,
                    level = 20,
                    items = {
                        { 6461 }, -- Slime-encrusted Pads
                        { 6627 }, -- Mutant Scale Breastplate
                        { 6463 }, -- Deep Fathom Ring
                        { 10441 }, -- Glowing Shard
                    },
                }
            }
        },
        {
            name = "ShadowfangKeep",
            id = 33,
            min = 14,
            recommended = {22,30},
            lore = "During the Third War, the wizards of the Kirin Tor battled against the undead armies of the Scourge. When the wizards of Dalaran died in battle, they would rise soon after - adding their former might to the growing Scourge. Frustrated by their lack of progress (and against the advice of his peers) the Archmage, Arugal elected to summon extra-dimensional entities to bolster Dalaran's diminishing ranks. Arugal's summoning brought the ravenous worgen into the world of Azeroth. The feral wolf-men slaughtered not only the Scourge, but quickly turned on the wizards themselves. The worgen sieged the keep of the noble, Baron Silverlaine. Situated above the tiny hamlet of Pyrewood, the keep quickly fell into shadow and ruin. Driven mad with guilt, Arugal adopted the worgen as his children and retreated to the newly dubbed 'Shadowfang Keep'. It's said he still resides there, protected by his massive pet, Fenrus - and haunted by the vengeful ghost of Baron Silverlaine.",
            bosses = {

            }
        },
        {
            name = "TheStockade",
            id = 34,
            min = 15,
            recommended = {24,31},
            lore = "The Stockades are a high-security prison complex, hidden beneath the canal district of Stormwind city. Presided over by Warden Thelwater, the Stockades are home to petty crooks, political insurgents, murderers and a score of the most dangerous criminals in the land. Recently, a prisoner-led revolt has resulted in a state of pandemonium within the Stockades - where the guards have been driven out and the convicts roam free. Warden Thelwater has managed to escape the holding area and is currently enlisting brave thrill-seekers to venture into the prison and kill the uprising's mastermind - the cunning felon, Bazil Thredd.",
            bosses = {
                
            }
        },
        {
            name = "BlackfathomDeeps",
            id = 48,
            min = 15,
            recommended = {24,32},
            lore = "Situated along the Zoram Strand of Ashenvale, Blackfathom Deeps was once a glorious temple dedicated to the night elves' moon-goddess, Elune. However, the great Sundering shattered the temple - sinking it beneath the waves of the Veiled Sea. There it remained untouched - until, drawn by its ancient power - the naga and satyr emerged to plumb its secrets. Legends hold that the ancient beast, Aku'mai, has taken up residence within the temple's ruins. Aku'mai, a favored pet of the primordial Old Gods, has preyed upon the area ever since. Drawn to Aku'mai's presence, the cult known as the Twilight's Hammer has also come to bask in the Old Gods' evil presence.",
            bosses = {
                
            }
        },
        {
            name = "Gnomeregan",
            id = 90,
            min = 19,
            recommended = {29,38},
            lore = "Located in Dun Morogh, the technological wonder known as Gnomeregan has been the gnomes' capital city for generations. Recently, a hostile race of mutant troggs infested several regions of Dun Morogh - including the great gnome city. In a desperate attempt to destroy the invading troggs, High Tinker Mekkatorque ordered the emergency venting of the city's radioactive waste tanks. Several gnomes sought shelter from the airborne pollutants as they waited for the troggs to die or flee. Unfortunately, though the troggs became irradiated from the toxic assault - their siege continued, unabated. Those gnomes who were not killed by noxious seepage were forced to flee, seeking refuge in the nearby dwarven city of Ironforge. There, High Tinker Mekkatorque set out to enlist brave souls to help his people reclaim their beloved city. It is rumored that Mekkatorque's once-trusted advisor, Mekgineer Thermaplug, betrayed his people by allowing the invasion to happen. Now, his sanity shattered, Thermaplug remains in Gnomeregan - furthering his dark schemes and acting as the city's new techno-overlord.",
            bosses = {
                
            }
        },
        {
            name = "RazorfenKraul",
            id = 47,
            min = 25,
            recommended = {29,38},
            lore = "Ten thousand years ago - during the War of the Ancients, the mighty demigod, Agamaggan, came forth to battle the Burning Legion. Though the colossal boar fell in combat, his actions helped save Azeroth from ruin. Yet over time, in the areas where his blood fell, massive thorn-ridden vines sprouted from the earth. The quillboar - believed to be the mortal offspring of the mighty god, came to occupy these regions and hold them sacred. The heart of these thorn-colonies was known as the Razorfen. The great mass of Razorfen Kraul was conquered by the old crone, Charlga Razorflank. Under her rule, the shamanistic quillboar stage attacks on rival tribes as well as Horde villages. Some speculate that Charlga has even been negotiating with agents of the Scourge - aligning her unsuspecting tribe with the ranks of the Undead for some insidious purpose.",
            bosses = {
                
            }
        },
        {
            name = "ScarletMonastery",
            id = 189,
            min = 21,
            recommended = {29,45},
            lore = "The Monastery was once a proud bastion of Lordaeron's priesthood - a center for learning and enlightenment. With the rise of the undead Scourge during the Third War, the peaceful Monastery was converted into a stronghold of the fanatical Scarlet Crusade. The Crusaders are intolerant of all non-human races, regardless of alliance or affiliation. They believe that any and all outsiders are potential carriers of the undead plague - and must be destroyed. Reports indicate that adventurers who enter the monastery are forced to contend with Scarlet Commander Mograine - who commands a large garrison of fanatically devoted warriors. However, the monastery's true master is High Inquisitor Whitemane - a fearsome priestess who possesses the ability to resurrect fallen warriors to do battle in her name.",
            bosses = {
                
            },
            wings = {
                {
                    name = "Graveyard",
                    recommended = {29,36}
                },
                {
                    name = "Library",
                    recommended = {32,39}
                },
                {
                    name = "Armory",
                    recommended = {36,43}
                },
                {
                    name = "Cathedral",
                    recommended = {38,45}
                },
            }
        },
        {
            name = "RazorfenDowns",
            id = 129,
            min = 35,
            recommended = {37,46},
            lore = "Crafted from the same mighty vines as Razorfen Kraul, Razorfen Downs is the traditional capital city of the quillboar race. The sprawling, thorn-ridden labyrinth houses a veritable army of loyal quillboar as well as their high priests - the Death's Head tribe. Recently, however, a looming shadow has fallen over the crude den. Agents of the undead Scourge - led by the lich, Amnennar the Coldbringer - have taken control over the quillboar race and turned the maze of thorns into a bastion of undead might. Now the quillboar fight a desperate battle to reclaim their beloved city before Amnennar spreads his control across the Barrens.",
            bosses = {
                
            }
        },
        {
            name = "Uldaman",
            id = 70,
            min = 30,
            recommended = {41,51},
            lore = "Uldaman is an ancient Titan vault that has laid buried deep within the earth since the world's creation. Dwarven excavations have recently penetrated this forgotten city, releasing the Titans' first failed creations: the Troggs. Legends say that the Titans created troggs from stone. When they deemed the experiment a failure, the Titans locked the troggs away and tried again - resulting in the creation of the dwarven race. The secrets of the dwarves' creation are recorded on the fabled Discs of Norgannon - massive Titan artifacts that lie at the very bottom of the ancient city. Recently, the Dark Iron dwarves have launched a series of incursions into Uldaman, hoping to claim the discs for their fiery master, Ragnaros. However, protecting the buried city are several guardians - giant constructs of living stone that crush any hapless intruders they find. The Discs themselves are guarded by a massive, sapient Stonekeeper called Archaedas. Some rumors even suggest that the dwarves' stone-skinned ancestors, the earthen, still dwell deep within the city's hidden recesses.",
            bosses = {
                
            }
        },
        {
            name = "ZulFarrak",
            id = 209,
            min = 39,
            recommended = {44,54},
            lore = "",
            bosses = {
                
            }
        },
        {
            name = "Maraudon",
            id = 349,
            min = 30,
            recommended = {46,55},
            lore = "Protected by the fierce Maraudine centaur, Maraudon is one of the most sacred sites within Desolace. The great temple/cavern is the burial place of Zaetar, one of two immortal sons born to the demigod, Cenarius. Legend holds that Zaetar and the earth elemental princess, Theradras, sired the misbegotten centaur race. It is said that upon their emergence, the barbaric centaur turned on their father and killed him. Some believe that Theradras, in her grief, trapped Zaetar's spirit within the winding cavern - used its energies for some malign purpose. The subterranean tunnels are populated by the vicious, long-dead ghosts of the Centaur Khans, as well as Theradras' own raging, elemental minions.",
            bosses = {
                
            }
        },
        {
            name = "SunkenTemple",
            id = 109,
            min = 45,
            recommended = {50,60},
            lore = "Over a thousand years ago, the powerful Gurubashi Empire was torn apart by a massive civil war. An influential group of troll priests, known as the Atal'ai, attempted to bring back an ancient blood god named Hakkar the Soulflayer. Though the priests were defeated and ultimately exiled, the great troll empire buckled in upon itself. The exiled priests fled far to the north, into the Swamp of Sorrows. There they erected a great temple to Hakkar - where they could prepare for his arrival into the physical world. The great dragon Aspect, Ysera, learned of the Atal'ai's plans and smashed the temple beneath the marshes. To this day, the temple's drowned ruins are guarded by the green dragons who prevent anyone from getting in or out. However, it is believed that some of the fanatical Atal'ai may have survived Ysera's wrath - and recommitted themselves to the dark service of Hakkar.",
            bosses = {
                
            }
        },
        {
            name = "BlackrockDepths",
            id = 230,
            min = 48,
            recommended = {52,60},
            lore = "Once the capital city of the Dark Iron dwarves, this volcanic labyrinth now serves as the seat of power for Ragnaros the Firelord. Ragnaros has uncovered the secret to creating life from stone and plans to build an army of unstoppable golems to aid him in conquering the whole of Blackrock Mountain. Obsessed with defeating Nefarian and his draconic minions, Ragnaros will go to any extreme to achieve final victory.",
            bosses = {
                
            }
        },
        {
            name = "BlackrockSpire",
            id = 229,
            min = 48,
            recommended = {55,60},
            lore = "The mighty fortress carved within the fiery bowels of Blackrock Mountain was designed by the master dwarf-mason, Franclorn Forgewright. Intended to be the symbol of Dark Iron power, the fortress was held by the sinister dwarves for centuries. However, Nefarian - the cunning son of the dragon, Deathwing - had other plans for the great keep. He and his draconic minions took control of the upper Spire and made war on the dwarves' holdings in the mountain's volcanic depths. Realizing that the dwarves were led by the mighty fire elemental, Ragnaros - Nefarian vowed to crush his enemies and claim the whole of Blackrock mountain for himself.",
            wings = {
                {
                    name = "Lower",
                    recommended = {55,60}
                },
                {
                    name = "Upper",
                    recommended = {58,60}
                }
            }
        },
        {
            name = "DireMaul",
            id = 429,
            min = 48,
            lore = "Built twelve thousand years ago by a covert sect of night elf sorcerers, the ancient city of Eldre'Thalas was used to protect Queen Azshara's most prized arcane secrets. Though it was ravaged by the Great Sundering of the world, much of the wondrous city still stands as the imposing Dire Maul. The ruins' three distinct districts have been overrun by all manner of creatures — especially the spectral Highborne, foul satyr and brutish ogres. Only the most daring party of adventurers can enter this broken city and face the ancient evils locked within its ancient vaults.",
            bosses = {
                
            },
            wings = {
                {
                    recommended = {55,60}
                },
                {
                    recommended = {56,60}
                },
                {
                    recommended = {56,60}
                },
            }
        },
        {
            name = "Scholomance",
            id = 289,
            min = 48,
            recommended = {58,60},
            lore = "The Scholomance is housed within a series of crypts that lie beneath the ruined keep of Caer Darrow. Once owned by the noble Barov family, Caer Darrow fell to ruin following the Second War. As the wizard Kel'thuzad enlisted followers for his Cult of the Damned he would often promise immortality in exchange for serving his Lich King. The Barov family fell to Kel'thuzad's charismatic influence and donated the keep and its crypts to the Scourge. The cultists then killed the Barovs and turned the ancient crypts into a school for necromancy known as the Scholomance. Though Kel'thuzad no longer resides in the crypts, devoted cultists and instructors still remain. The powerful lich, Ras Frostwhisper, rules over the site and guards it in the Scourge's name - while the mortal necromancer, Darkmaster Gandling, serves as the school's insidious headmaster.",
            bosses = {
                
            }
        },
        {
            name = "Stratholme",
            id = 329,
            min = 48,
            recommended = {58,60},
            lore = "Once the jewel of northern Lordaeron, the city of Stratholme is where Prince Arthas turned against his mentor, Uther Lightbringer, and slaughtered hundreds of his own subjects who were believed to have contracted the dreaded plague of undeath. Arthas' downward spiral and ultimate surrender to the Lich King soon followed. The broken city is now inhabited by the undead Scourge -- led by the powerful lich, Kel'Thuzad. A contingent of Scarlet Crusaders, led by Grand Crusader Dathrohan, also holds a portion of the ravaged city. The two sides are locked in constant, violent combat. Those adventurers brave (or foolish) enough to enter Stratholme will be forced to contend with both factions before long. It is said that the city is guarded by three massive watchtowers, as well as powerful necromancers, banshees and abominations. There have also been reports of a malefic Death Knight riding atop an unholy steed, dispensing indiscriminate wrath on all those who venture within the realm of the Scourge.",
            bosses = {
                
            }
        },
    },
    Raids = {
        {
            name = "MoltenCore",
            id = 409,
            recommended = {58,60},
            lore = "The Molten Core lies at the very bottom of Blackrock Depths. It is the heart of Blackrock Mountain and the exact spot where, long ago in a desperate bid to turn the tide of the dwarven civil war, Emperor Thaurissan summoned the elemental Firelord, Ragnaros, into the world. Though the firelord is incapable of straying far from the blazing Core, it is believed that his elemental minions command the Dark Iron dwarves, who are in the midst of creating armies out of living stone. The burning lake where Ragnaros lies sleeping acts as a rift connecting to the plane of fire, allowing the malicious elementals to pass through. Chief among Ragnaros' agents is Majordomo Executus - for this cunning elemental is the only one capable of calling the Firelord from his slumber.",
            bosses = {
                {
                    name = "Lucifron",
                    id = 12118,
                    displayId = 13031,
                    level = DJ.BOSS_LEVEL,
                    lore = "Among the ranks of the flamewakers, overseers and their guards constantly jockey for higher status among the hierarchy of elementals in hopes of gaining favor with Ragnaros. Lucifron is no exception. He has clashed with Gehennas on several occasions, particularly during their incarceration within the Elemental Plane. This rivalry has now extended to the Molten Core where Lucifron quietly waits for his opportunity to capitalize on any weakness shown by the other flamewakers.",
                    items = {
                        { 16800 },	-- Arcanist Boots
                        { 16805 },	-- Felheart Gloves
                        { 16829 },	-- Cenarion Boots
                        { 16837 },	-- Earthfury Boots
                        { 16859 },	-- Lawbringer Boots
                        { 16863 },	-- Gauntlets of Might
                        { 18870 },	-- Helm of the Lifegiver
                        { 17109 },	-- Choker of Enlightenment
                        { 19145 },	-- Robe of Volatile Power
                        { 19146 },	-- Wristguards of Stability
                        { 18872 },	-- Manastorm Leggings
                        { 18875 },	-- Salamander Scale Pants
                        { 18861 },	-- Flamewaker Legplates
                        { 18879 },	-- Heavy Dark Iron Ring
                        { 19147 },	-- Ring of Spell Power
                        { 17077 },	-- Crimson Shocker
                        { 18878 },	-- Sorcerous Dagger
                        { 16665 },	-- Tome of Tranquilizing Shot
                    },
                },
                {
                    name = "Magmadar",
                    id = 11982,
                    displayId = 10193,
                    level = DJ.BOSS_LEVEL,
                    lore = "A terrifying behemoth composed of igneous rock and roiling magma, Magmadar serves as the origin of the core hounds that roam the earthen halls of Molten Core. Favored among Ragnaros's pets, Magmadar is protected by the flamewaker Lucifron and surrounded by vicious packs of ravenous hounds. It is said that while Ragnaros was imprisoned in the Elemental Plane, the Firelord would feed the remains of his captured enemies to the eagerly awaiting twin maws of Magmadar. As a result, the hound grew strong and loyal, and even now Magmadar's savage ferocity remains uncontested.",
                    items= {
                        { 16814 },	-- Pants of Prophecy
                        { 16796 },	-- Arcanist Leggings
                        { 16810 },	-- Felheart Pants
                        { 16822 },	-- Nightslayer Pants
                        { 16835 },	-- Cenarion Leggings
                        { 16847 },	-- Giantstalker's Leggings
                        { 16843 },	-- Earthfury Legguards
                        { 16855 },	-- Lawbringer Legplates
                        { 16867 },	-- Legplates of Might
                        { 18203 },	-- Eskhandar's Right Claw
                        { 17065 },	-- Medallion of Steadfast Might
                        { 18829 },	-- Deep Earth Spaulders
                        { 18823 },	-- Aged Core Leather Gloves
                        { 19143 },	-- Flameguard Gauntlets
                        { 19136 },	-- Mana Igniting Cord
                        { 18861 },	-- Flamewaker Legplates
                        { 19144 },	-- Sabatons of the Flamewalker
                        { 18824 },	-- Magma Tempered Boots
                        { 18821 },	-- Quick Strike Ring
                        { 18820 },	-- Talisman of Ephemeral Power
                        { 19142 },	-- Fire Runed Grimoire
                        { 17069 },	-- Striker's Mark
                        { 17073 },	-- Earthshaker
                        { 18822 },	-- Obsidian Edged Blade
                    },
                },
                {
                    name = "Gehennas",
                    id = 12259,
                    displayId = 13030,
                    level = DJ.BOSS_LEVEL,
                    lore = "Gehennas and his fellow flamewakers were extricated from the Elemental Plane by Ragnaros shortly after Thaurissan accidentally summoned the Firelord. Unlike the fire elementals, who are beings of pure flame, the flamewakers are elementals composed of flesh and blood. Gehennas resides near the bottom of the Firelord's elemental hierarchy and covets the power and station of his superiors. He is distrusted by all who serve with him, with the exception of his two loyal guards, who believe they might gain from their overseer's ascension.",
                    items = {
                        { 16812 },	-- Gloves of Prophecy
                        { 16826 },	-- Nightslayer Gloves
                        { 16849 },	-- Giantstalker's Boots
                        { 16839 },	-- Earthfury Gauntlets
                        { 16860 },	-- Lawbringer Gauntlets
                        { 16862 },	-- Sabatons of Might
                        { 18870 },	-- Helm of the Lifegiver
                        { 19145 },	-- Robe of Volatile Power
                        { 19146 },	-- Wristguards of Stability
                        { 18872 },	-- Manastorm Leggings
                        { 18875 },	-- Salamander Scale Pants
                        { 18861 },	-- Flamewaker Legplates
                        { 18879 },	-- Heavy Dark Iron Ring
                        { 19147 },	-- Ring of Spell Power
                        { 17077 },	-- Crimson Shocker
                        { 18878 },	-- Sorcerous Dagger
                    },
                },
                {
                    name = "Garr",
                    id = 12057,
                    displayId = 12110,
                    level = DJ.BOSS_LEVEL,
                    lore = "As one of the two chief lieutenants serving under Ragnaros, Garr plays a key role in the current success of the Firelord and his spreading influence. Garr, like Baron Geddon, holds half of Bindings of the Windseeker, which contains the remaining essence of Thunderaan, Prince of Air. Tales say that after centuries of partnership, Geddon became suspicious of Garr and felt the elemental sought both halves of the talisman. Thus, relations between the two powers are strained. Both Garr and Baron Geddon draw their considerable might from the blazing runes carved deep into the floor of Molten Core.",
                    items = {
                        { 18564 },	-- Bindings of the Windseeker
                        { 16813 },	-- Circlet of Prophecy
                        { 16795 },	-- Arcanist Crown
                        { 16808 },	-- Felheart Horns
                        { 16821 },	-- Nightslayer Cover
                        { 16834 },	-- Cenarion Helm
                        { 16846 },	-- Giantstalker's Helmet
                        { 16842 },	-- Earthfury Helmet
                        { 16854 },	-- Lawbringer Helm
                        { 16866 },	-- Helm of Might
                        { 18829 },	-- Deep Earth Spaulders
                        { 18823 },	-- Aged Core Leather Gloves
                        { 19143 },	-- Flameguard Gauntlets
                        { 19136 },	-- Mana Igniting Cord
                        { 18861 },	-- Flamewaker Legplates
                        { 19144 },	-- Sabatons of the Flamewalker
                        { 18824 },	-- Magma Tempered Boots
                        { 18821 },	-- Quick Strike Ring
                        { 18820 },	-- Talisman of Ephemeral Power
                        { 19142 },	-- Fire Runed Grimoire
                        { 17066 },	-- Drillborer Disk
                        { 17071 },	-- Gutgore Ripper
                        { 17105 },	-- Aurastone Hammer
                        { 18832 },	-- Brutality Blade
                        { 18822 },	-- Obsidian Edged Blade
                    },
                },
                {
                    name = "Shazzrah",
                    id = 12264,
                    displayId = 13032,
                    level = DJ.BOSS_LEVEL,
                    lore = "Of all the flamewakers who followed Ragnaros into the world of Azeroth, Shazzrah is the most talented in the realm of the arcane. He is aware that his colleague Baron Geddon suspects the elemental Garr of treachery. The conflict between Baron Geddon and Garr suits Shazzrah well, for in fact it is Shazzrah who seeks to posses both halves of the Talisman of Elemental Binding so that he might find a way to siphon its energies for his own use. Ragnaros was very likely aware of his underling's penchant for duplicity when he split the talisman in half and entrusted the pieces to Baron Geddon and Garr.",
                    items = {
                        { 16811 },	-- Boots of Prophecy
                        { 16801 },	-- Arcanist Gloves
                        { 16803 },	-- Felheart Slippers
                        { 16824 },	-- Nightslayer Boots
                        { 16831 },	-- Cenarion Gloves
                        { 16852 },	-- Giantstalker's Gloves
                        { 18870 },	-- Helm of the Lifegiver
                        { 19145 },	-- Robe of Volatile Power
                        { 19146 },	-- Wristguards of Stability
                        { 18872 },	-- Manastorm Leggings
                        { 18875 },	-- Salamander Scale Pants
                        { 18861 },	-- Flamewaker Legplates
                        { 18879 },	-- Heavy Dark Iron Ring
                        { 19147 },	-- Ring of Spell Power
                        { 17077 },	-- Crimson Shocker
                        { 18878 },	-- Sorcerous Dagger
                    },
                },
                {
                    name = "Baron Geddon",
                    id = 12056,
                    displayId = 12129,
                    level = DJ.BOSS_LEVEL,
                    lore = "When Ragnaros was ripped from the Elemental Plane by the Sorcerer-Thane Thaurissan, several subjects from the Firelands followed in his wake. Baron Geddon fought against the titans and aided in the betrayal of Thunderaan, Prince of Air. The Firelord devoured the essence of the prince, but was unable to consume him entirely. Thus, the remaining energies were trapped within a talisman of elemental binding, which Ragnaros split into two perfect halves which he gave to his two lieutenants.\nRumour has it that Executus supplanted Baron Geddon, and the two have been rivals ever since. Although this rumour has yet to be confirmed, there is certainly no doubt that Ragnaros does not tolerate failure. Thus, the lesser flamewakers (and, of course, Baron Geddon) eagerly awaited a misstep by Executus, anticipating their chance to vie for the coveted attention of the Firelord.",
                    items = {
                        { 18563 },	-- Bindings of the Windseeker
                        { 16797 },	-- Arcanist Mantle
                        { 16807 },	-- Felheart Shoulder Pads
                        { 16836 },	-- Cenarion Spaulders
                        { 16844 },	-- Earthfury Epaulets
                        { 16856 },	-- Lawbringer Spaulders
                        { 18829 },	-- Deep Earth Spaulders
                        { 18823 },	-- Aged Core Leather Gloves
                        { 19143 },	-- Flameguard Gauntlets
                        { 19136 },	-- Mana Igniting Cord
                        { 18861 },	-- Flamewaker Legplates
                        { 19144 },	-- Sabatons of the Flamewalker
                        { 18824 },	-- Magma Tempered Boots
                        { 18821 },	-- Quick Strike Ring
                        { 17110 },	-- Seal of the Archmagus
                        { 18820 },	-- Talisman of Ephemeral Power
                        { 19142 },	-- Fire Runed Grimoire
                        { 18822 },	-- Obsidian Edged Blade
                    },
                },
                {
                    name = "Golemagg the Incinerator",
                    id = 11988,
                    displayId = 11986,
                    level = DJ.BOSS_LEVEL,
                    lore = "The most feared soldiers of Ragnaros's elemental forces are the molten giants, and among them Golemagg the Incinerator is unrivaled for his sheer brutality and savage efficiency. So absolute is the molten behemoth's power that he has cowed two core ragers — offspring of the colossal beast Magmadar — which he now uses as pets. For this affront, he has earned Magmadar's eternal and unwavering ire, although the fearsome creature has yet to act on his savage impulses.",
                    items = {
                        { 16815 },	-- Robes of Prophecy
                        { 16798 },	-- Arcanist Robes
                        { 16809 },	-- Felheart Robes
                        { 16820 },	-- Nightslayer Chestpiece
                        { 16833 },	-- Cenarion Vestments
                        { 16845 },	-- Giantstalker's Breastplate
                        { 16841 },	-- Earthfury Vestments
                        { 16853 },	-- Lawbringer Chestguard
                        { 16865 },	-- Breastplate of Might
                        { 17203 },	-- Sulfuron Ingot
                        { 18829 },	-- Deep Earth Spaulders
                        { 18823 },	-- Aged Core Leather Gloves
                        { 19143 },	-- Flameguard Gauntlets
                        { 19136 },	-- Mana Igniting Cord
                        { 18861 },	-- Flamewaker Legplates
                        { 19144 },	-- Sabatons of the Flamewalker
                        { 18824 },	-- Magma Tempered Boots
                        { 18821 },	-- Quick Strike Ring
                        { 18820 },	-- Talisman of Ephemeral Power
                        { 19142 },	-- Fire Runed Grimoire
                        { 17072 },	-- Blastershot Launcher
                        { 17103 },	-- Azuresong Mageblade
                        { 18822 },	-- Obsidian Edged Blade
                        { 18842 },	-- Staff of Dominance
                    },
                },
                {
                    name = "Sulfuron Harbinger",
                    id = 12098,
                    displayId = 13030,
                    level = DJ.BOSS_LEVEL,
                    lore = "Among the most favored of the flamewakers, Sulfuron Harbinger is the terrifying herald of Ragnaros himself. From the infernal depths of the Molten Core, the Harbinger commands Ambassador Flamelash and the other lesser flamewakers in the outside world. Sulfuron Harbinger answers only to Executus and guards the rune of Koro, one of several runes that empower the Firelord's servants. Sulfuron Harbinger keeps Shazzrah in particular under close watch, believing that Shazzrah seeks to betray Ragnaros. Flanked by four of the Firelord's most fervid priests, the Harbinger prepares for the day when the elemental lord of fire claims the world of Azeroth for his own.",
                    items = {
                        { 16816 }, -- Mantle of Prophecy
                        { 16823 }, -- Nightslayer Shoulder Pads
                        { 16848 }, -- Giantstalker's Epaulets
                        { 16868 }, -- Pauldrons of Might
                        { 18870 }, -- Helm of the Lifegiver
                        { 19145 }, -- Robe of Volatile Power
                        { 19146 }, -- Wristguards of Stability
                        { 18872 }, -- Manastorm Leggings
                        { 18875 }, -- Salamander Scale Pants
                        { 18861 }, -- Flamewaker Legplates
                        { 18879 }, -- Heavy Dark Iron Ring
                        { 19147 }, -- Ring of Spell Power
                        { 17077 }, -- Crimson Shocker
                        { 18878 }, -- Sorcerous Dagger
                        { 17074 }, -- Shadowstrike
                    },
                },
                {
                    name = "Majordomo Executus",
                    id = 12018,
                    displayId = 12029,
                    level = DJ.BOSS_LEVEL,
                    lore = "At the top of the elemental hierarchy, just beneath Ragnaros himself, resides Majordomo Executus. This flamewaker gained his exalted status by proving to be nearly invincible in the battles that raged within the elemental plane. Rumor has it that Executus supplanted Baron Geddon, and the two have been rivals ever since. Although this rumor has yet to be confirmed, there is certainly no doubt that Ragnaros does not tolerate failure. Thus, the lesser flamewakers (and, of course, Baron Geddon) eagerly await a misstep by Executus, anticipating their chance to vie for the coveted attention of the Firelord.",
                    items = {
                        { 19139 }, -- Fireguard Shoulders
                        { 18810 }, -- Wild Growth Spaulders
                        { 18811 }, -- Fireproof Cloak
                        { 18808 }, -- Gloves of the Hypnotic Flame
                        { 18809 }, -- Sash of Whispered Secrets
                        { 18812 }, -- Wristguards of True Flight
                        { 18806 }, -- Core Forged Greaves
                        { 19140 }, -- Cauterizing Band
                        { 18805 }, -- Core Hound Tooth
                        { 18803 }, -- Finkle's Lava Dredger
                        { 18703 }, -- Ancient Petrified Leaf
                        { 18646 }, -- The Eye of Divinity
                    },
                },
                {
                    name = "Ragnaros",
                    id = 11502,
                    displayId = 11121,
                    displayPosition = { -2, 0, -2.5 },
                    level = DJ.BOSS_LEVEL,
                    lore = "The Firelord and his brethren once held sway over the entire world. As a servant of the Old Gods, he fought against the Titans for domination over the planet. The victorious Titans banished him and his brethren to the Elemental Plane — there to remain imprisoned until the end of time.\nNow, freed by Thaurissan's call, Ragnaros erupted into being once again. Ragnaros' apocalyptic rebirth into Azeroth shattered the Redridge Mountains and created a raging volcano at the center of the devastation.\nNow he lies at the bottom of that volcano on Azeroth, striving to find a way home, as well as to gather his strength once again so he can burn away Azeroth and take it for his own. Meanwhile, in Sulfuron Keep and elsewhere across the Firelands, his elemental princes battle constantly for dominance. He and his dwarven minions took control of the Blackrock mountain's volcanic depths and made war on the orcs in the Upper Blackrock Spire, which served as the seat of power for Nefarian the black dragon. Ragnaros has uncovered the secret to creating life from stone and plans to build an army of unstoppable golems to aid him in conquering the whole of Blackrock Mountain.",
                    items = {
                        { 17204 }, -- Eye of Sulfuras
                        { 19017 }, -- Essence of the Firelord
                        { 16922 }, -- Leggings of Transcendence
                        { 16915 }, -- Netherwind Pants
                        { 16930 }, -- Nemesis Leggings
                        { 16909 }, -- Bloodfang Pants
                        { 16901 }, -- Stormrage Legguards
                        { 16938 }, -- Dragonstalker's Legguards
                        { 16946 }, -- Legplates of Ten Storms
                        { 16954 }, -- Judgement Legplates
                        { 16962 }, -- Legplates of Wrath
                        { 17082 }, -- Shard of the Flame
                        { 18817 }, -- Crown of Destruction
                        { 18814 }, -- Choker of the Fire Lord
                        { 17102 }, -- Cloak of the Shrouded Mists
                        { 17107 }, -- Dragon's Blood Cape
                        { 19137 }, -- Onslaught Girdle
                        { 17063 }, -- Band of Accuria
                        { 19138 }, -- Band of Sulfuras
                        { 18815 }, -- Essence of the Pure Flame
                        { 17106 }, -- Malistar's Defender
                        { 18816 }, -- Perdition's Blade
                        { 17104 }, -- Spinal Reaper
                        { 17076 }, -- Bonereaver's Edge
                    },
                },
            }
        },
        {
            name = "Onyxia",
            id = 249,
            recommended = {50,60},
            lore = "Onyxia is the daughter of the mighty Black Aspect, Deathwing, and sister of the scheming Nefarian, Lord of Blackrock Spire. Whereas her father favors brute force, and her brother creates twisted abominations to carry out his will, Onyxia prefers subtle manipulation, and delights in meddling in the political affairs of mortals, using her charm and power to influence such delicate matters between the different races to her own ends. Some believe that Onyxia has even assumed an alias once used by her father - the title of the royal House Prestor. Most recently, she very nearly succeeded in destroying the political structure of Stormwind in the guise of Katrana Prestor, before being unmasked by Marshal Windsor and fleeing to her lair: a fiery cave below the Dragonmurk, a dismal swamp located within Dustwallow Marsh. There she is guarded by her kin, the remaining members of the insidious black dragonflight.",
            bosses = {
                { 
                    name = "Onyxia",
                    id = 10184,
                    displayId = 8570,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 16921 }, -- Halo of Transcendence
                        { 16914 }, -- Netherwind Crown
                        { 16929 }, -- Nemesis Skullcap
                        { 16908 }, -- Bloodfang Hood
                        { 16900 }, -- Stormrage Cover
                        { 16939 }, -- Dragonstalker's Helm
                        { 16947 }, -- Helmet of Ten Storms
                        { 16955 }, -- Judgement Crown
                        { 16963 }, -- Helm of Wrath
                        { 18423 }, -- Head of Onyxia
                        { 15410 }, -- Scale of Onyxia
                        { 18705 }, -- Mature Black Dragon Sinew
                        { 18205 }, -- Eskhandar's Collar
                        { 17078 }, -- Sapphiron Drape
                        { 18813 }, -- Ring of Binding
                        { 17064 }, -- Shard of the Scale
                        { 17067 }, -- Ancient Cornerstone Grimoire
                        { 17068 }, -- Deathbringer
                        { 17075 }, -- Vis'kag the Bloodletter
                        { 17966 }, -- Onyxia Hide Backpack
                        { 11938 }, -- Sack of Gems
                    },
                },
            }
        },
        {
            name = "BlackwingLair",
            id = 469,
            recommended = {60,60},
            lore = "In the dark recesses of the mountain's peak, Nefarian, the eldest son of Deathwing, conducts some of his most awful experimentation, controlling mighty beings like puppets and combining the eggs of different dragonflights with horrific results. Should he prove successful, even darker pursuits rest on the horizon. And, yet, the Lord of Blackrock is not a mere scientist - he is a great dragon cornered in his lair. Can he truly be defeated by mortal hands?",
            bosses = {
                {
                    name = "Razorgore the Untamed",
                    id = 12435,
                    displayId = 10115,
                    level = DJ.BOSS_LEVEL,
                    lore = "As one of the higher ranking Black Dragons, Razorgore was tasked by Nefarian with guarding the numerous black dragon eggs. To carry on with this task, Razorgore was given control of a battalion of Blackrock Orcs, and will stop at nothing to ensure his master's will is done.",
                    items = {
                        { 16926 }, -- Bindings of Transcendence
                        { 16918 }, -- Netherwind Bindings
                        { 16934 }, -- Nemesis Bracers
                        { 16911 }, -- Bloodfang Bracers
                        { 16904 }, -- Stormrage Bracers
                        { 16935 }, -- Dragonstalker's Bracers
                        { 16943 }, -- Bracers of Ten Storms
                        { 16951 }, -- Judgement Bindings
                        { 16959 }, -- Bracelets of Wrath
                        { 19336 }, -- Arcane Infused Gem
                        { 19337 }, -- The Black Book
                        { 19370 }, -- Mantle of the Blackwing Cabal
                        { 19369 }, -- Gloves of Rapid Evolution
                        { 19335 }, -- Spineshatter
                        { 19334 }, -- The Untamed Blade
                    },
                },
                {
                    name = "Vaelastrasz the Corrupt",
                    id = 13020,
                    displayId = 13992,
                    level = DJ.BOSS_LEVEL,
                    lore = "Vaelastrasz is a member of the Dragonqueen Alexstrasza's red dragonflight who fought against - and became enslaved by - the vile Nefarian, son of Deathwing, master of the black and chromatic dragonflights. He resides in Nefarian's citadel of Blackwing Lair. One of the red Dragon Aspect’s strongest children, Vaelastrasz takes it upon himself to oppose the black dragonflight.",
                    items = {
                        { 16925 }, -- Belt of Transcendence
                        { 16818 }, -- Netherwind Belt
                        { 16933 }, -- Nemesis Belt
                        { 16910 }, -- Bloodfang Belt
                        { 16903 }, -- Stormrage Belt
                        { 16936 }, -- Dragonstalker's Belt
                        { 16944 }, -- Belt of Ten Storms
                        { 16952 }, -- Judgement Belt
                        { 16960 }, -- Waistband of Wrath
                        { 19339 }, -- Mind Quickening Gem
                        { 19340 }, -- Rune of Metamorphosis
                        { 19372 }, -- Helm of Endless Rage
                        { 19371 }, -- Pendant of the Fallen Dragon
                        { 19348 }, -- Red Dragonscale Protector
                        { 19346 }, -- Dragonfang Blade
                    },
                },
                {
                    name = "Broodlord Lashlayer",
                    id = 12017,
                    displayId = 14308,
                    level = DJ.BOSS_LEVEL,
                    lore = "Broodlord Lashlayer guards the Halls of Strife, blocking the way into Nefarian's inner sanctum.",
                    items = {
                        { 16919 }, -- Boots of Transcendence
                        { 16912 }, -- Netherwind Boots
                        { 16927 }, -- Nemesis Boots
                        { 16906 }, -- Bloodfang Boots
                        { 16898 }, -- Stormrage Boots
                        { 16941 }, -- Dragonstalker's Greaves
                        { 16949 }, -- Greaves of Ten Storms
                        { 16957 }, -- Judgement Sabatons
                        { 16965 }, -- Sabatons of Wrath
                        { 19341 }, -- Lifegiving Gem
                        { 19342 }, -- Venomous Totem
                        { 19373 }, -- Black Brood Pauldrons
                        { 19374 }, -- Bracers of Arcane Accuracy
                        { 19350 }, -- Heartstriker
                        { 19351 }, -- Maladath, Runed Blade of the Black Flight
                        { 20383 }, -- Head of the Broodlord Lashlayer
                    },
                },
                {
                    name = "Firemaw",
                    id = 11983,
                    displayId = 6377,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 16920 }, -- Handguards of Transcendence
                        { 16913 }, -- Netherwind Gloves
                        { 16928 }, -- Nemesis Gloves
                        { 16907 }, -- Bloodfang Gloves
                        { 16899 }, -- Stormrage Handguards
                        { 16940 }, -- Dragonstalker's Gauntlets
                        { 16948 }, -- Gauntlets of Ten Storms
                        { 16956 }, -- Judgement Gauntlets
                        { 16964 }, -- Gauntlets of Wrath
                        { 19344 }, -- Natural Alignment Crystal
                        { 19343 }, -- Scrolls of Blinding Light
                        { 19394 }, -- Drake Talon Pauldrons
                        { 19398 }, -- Cloak of Firemaw
                        { 19399 }, -- Black Ash Robe
                        { 19400 }, -- Firemaw's Clutch
                        { 19396 }, -- Taut Dragonhide Belt
                        { 19401 }, -- Primalist's Linked Legguards
                        { 19402 }, -- Legguards of the Fallen Crusader
                        { 19365 }, -- Claw of the Black Drake
                        { 19353 }, -- Drake Talon Cleaver
                        { 19355 }, -- Shadow Wing Focus Staff
                        { 19397 }, -- Ring of Blackrock
                        { 19395 }, -- Rejuvenating Gem
                    },
                },
                {
                    name = "Ebonroc",
                    id = 14601,
                    displayId = 6377,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 16920 }, -- Handguards of Transcendence
                        { 16913 }, -- Netherwind Gloves
                        { 16928 }, -- Nemesis Gloves
                        { 16907 }, -- Bloodfang Gloves
                        { 16899 }, -- Stormrage Handguards
                        { 16940 }, -- Dragonstalker's Gauntlets
                        { 16948 }, -- Gauntlets of Ten Storms
                        { 16956 }, -- Judgement Gauntlets
                        { 16964 }, -- Gauntlets of Wrath
                        { 19345 }, -- Aegis of Preservation
                        { 19406 }, -- Drake Fang Talisman
                        { 19395 }, -- Rejuvenating Gem
                        { 19394 }, -- Drake Talon Pauldrons
                        { 19407 }, -- Ebony Flame Gloves
                        { 19396 }, -- Taut Dragonhide Belt
                        { 19405 }, -- Malfurion's Blessed Bulwark
                        { 19368 }, -- Dragonbreath Hand Cannon
                        { 19353 }, -- Drake Talon Cleaver
                        { 19355 }, -- Shadow Wing Focus Staff
                        { 19403 }, -- Band of Forced Concentration
                        { 19397 }, -- Ring of Blackrock
        
                    },
                },
                {
                    name = "Flamegor",
                    id = 11981,
                    displayId = 6377,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 16920 }, -- Handguards of Transcendence
                        { 16913 }, -- Netherwind Gloves
                        { 16928 }, -- Nemesis Gloves
                        { 16907 }, -- Bloodfang Gloves
                        { 16899 }, -- Stormrage Handguards
                        { 16940 }, -- Dragonstalker's Gauntlets
                        { 16948 }, -- Gauntlets of Ten Storms
                        { 16956 }, -- Judgement Gauntlets
                        { 16964 }, -- Gauntlets of Wrath
                        { 19395 }, -- Rejuvenating Gem
                        { 19431 }, -- Styleen's Impeding Scarab
                        { 19394 }, -- Drake Talon Pauldrons
                        { 19430 }, -- Shroud of Pure Thought
                        { 19396 }, -- Taut Dragonhide Belt
                        { 19433 }, -- Emberweave Leggings
                        { 19367 }, -- Dragon's Touch
                        { 19353 }, -- Drake Talon Cleaver
                        { 19357 }, -- Herald of Woe
                        { 19355 }, -- Shadow Wing Focus Staff
                        { 19432 }, -- Circle of Applied Force
                        { 19397 }, -- Ring of Blackrock
                    },
                },
                {
                    name = "Chromaggus",
                    id = 14020,
                    displayId = 14367,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 16924 }, -- Pauldrons of Transcendence
                        { 16917 }, -- Netherwind Mantle
                        { 16932 }, -- Nemesis Spaulders
                        { 16832 }, -- Bloodfang Spaulders
                        { 16902 }, -- Stormrage Pauldrons
                        { 16937 }, -- Dragonstalker's Spaulders
                        { 16945 }, -- Epaulets of Ten Storms
                        { 16953 }, -- Judgement Spaulders
                        { 16961 }, -- Pauldrons of Wrath
                        { 19389 }, -- Taut Dragonhide Shoulderpads
                        { 19386 }, -- Elementium Threaded Cloak
                        { 19390 }, -- Taut Dragonhide Gloves
                        { 19388 }, -- Angelista's Grasp
                        { 19393 }, -- Primalist's Linked Waistguard
                        { 19392 }, -- Girdle of the Fallen Crusader
                        { 19385 }, -- Empowered Leggings
                        { 19391 }, -- Shimmering Geta
                        { 19387 }, -- Chromatic Boots
                        { 19361 }, -- Ashjre'thul, Crossbow of Smiting
                        { 19349 }, -- Elementium Reinforced Bulwark
                        { 19347 }, -- Claw of Chromaggus
                        { 19352 }, -- Chromatically Tempered Sword
                    },
                },
                {
                    name = "Nefarian",
                    id = 11583,
                    displayId = 11380,
                    level = DJ.BOSS_LEVEL,
                    lore = "Nefarian (also known as Blackwing) is a black dragon and the eldest son of Deathwing. He appears in his human guise as Lord Victor Nefarius, the Lord of Blackrock. Holding the Blackrock clan and various clans of ogres under his control, Nefarian rules from his lair at the top of Blackrock Spire.\nIn Blackrock, aided by his loyal dragonspawn, he fights a constant battle with Ragnaros and his forces for control of the mountain and, ultimately, control of the entire region. To this end, he made efforts to bolster his forces like his father Deathwing in ages past. Nefarian delights in capturing Ragnaros' elemental minions and using them for his own insidious purposes.",
                    items = {
                        { 16923 }, -- Robes of Transcendence
                        { 16916 }, -- Netherwind Robes
                        { 16931 }, -- Nemesis Robes
                        { 16905 }, -- Bloodfang Chestpiece
                        { 16897 }, -- Stormrage Chestguard
                        { 16942 }, -- Dragonstalker's Breastplate
                        { 16950 }, -- Breastplate of Ten Storms
                        { 16958 }, -- Judgement Breastplate
                        { 16966 }, -- Breastplate of Wrath
                        { 19003 }, -- Head of Nefarian
                        { 19360 }, -- Lok'amir il Romathis
                        { 19363 }, -- Crul'shorukh, Edge of Chaos
                        { 19364 }, -- Ashkandi, Greatsword of the Brotherhood
                        { 19356 }, -- Staff of the Shadow Flame
                        { 19375 }, -- Mish'undare, Circlet of the Mind Flayer
                        { 19377 }, -- Prestor's Talisman of Connivery
                        { 19378 }, -- Cloak of the Brood Lord
                        { 19380 }, -- Therazane's Link
                        { 19381 }, -- Boots of the Shadow Flame
                        { 19376 }, -- Archimtiros' Ring of Reckoning
                        { 19382 }, -- Pure Elementium Band
                        { 19379 }, -- Neltharion's Tear
                        { 11938 }, -- Sack of Gems
                    },
                },
            }
        },
        {
            name = "ZulGurub",
            id = 309,
            recommended = {60,60},
            lore = "1,500 years before the opening of the Dark Portal, the powerful Gurubashi Empire was torn apart by a massive civil war. An influential group of troll priests, known as the Atal'ai, called forth the avatar of an ancient and terrible blood-god named Hakkar the Soulflayer. Though the priests were defeated and ultimately exiled, the great troll empire collapsed upon itself. The exiled priests fled far to the north, into the Swamp of Sorrows, where they erected a great temple to Hakkar in order to prepare for his arrival into the physical world. In time, the Atal'ai priests discovered that Hakkar's physical form could only be summoned within the ancient capital of the Gurubashi Empire. It was in Zul'Gurub that Jin'do the Hexxer enslaved several high priests of the Gurubashi to aid him in summoning their dread god, Hakkar the Soulflayer, into Azeroth. In order to quell the blood god, the trolls of the land banded together and sent a contingent of High Priests into the ancient city. Each priest was a powerful champion of the Primal Gods - Bat, Panther, Tiger, Spider, and Snake - but despite their best efforts, they fell under the sway of Hakkar. The champions and their Primal God aspects started feeding the awesome power of the Soulflayer.",
            bosses = {
                {
                    name = "High Priestess Jeklik",
                    imageName = "Default",
                    id = 14517,
                    displayId = 15219,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 1,  19721 }, -- Primal Hakkari Shawl
                        { 2,  19724 }, -- Primal Hakkari Aegis
                        { 3,  19723 }, -- Primal Hakkari Kossack
                        { 4,  19722 }, -- Primal Hakkari Tabard
                        { 5,  19717 }, -- Primal Hakkari Armsplint
                        { 6,  19716 }, -- Primal Hakkari Bindings
                        { 7,  19718 }, -- Primal Hakkari Stanchion
                        { 8,  19719 }, -- Primal Hakkari Girdle
                        { 9,  19720 }, -- Primal Hakkari Sash
                        { 16, 19918 }, -- Jeklik's Crusher
                        { 18, 19923 }, -- Jeklik's Opaline Talisman
                        { 19, 19928 }, -- Animist's Spaulders
                        { 20, 20262 }, -- Seafury Boots
                        { 21, 20265 }, -- Peacekeeper Boots
                        { 22, 19920 }, -- Primalist's Band
                        { 23, 19915 }, -- Zulian Defender
                    },
                },
                {
                    name = "High Priest Venoxis",
                    id =  14507,
                    displayId = 15217,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 19904 }, -- Runed Bloodstained Hauberk
                        { 19903 }, -- Fang of Venoxis
                        { 19907 }, -- Zulian Tigerhide Cloak
                        { 19906 }, -- Blooddrenched Footpads
                        { 19905 }, -- Zanzil's Band
                        { 19900 }, -- Zulian Stone Axe
                    },
                },
                {
                    name = "High Priestess Mar'li",
                    imageName = "Default", -- TODO: boss image (Shadow Hunter Voshgajin?)
                    id =  14510,
                    displayId = 15220,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 20032 }, -- Flowing Ritual Robes
                        { 19927 }, -- Mar'li's Touch
                        { 19871 }, -- Talisman of Protection
                        { 19919 }, -- Bloodstained Greaves
                        { 19925 }, -- Band of Jin
                        { 19930 }, -- Mar'li's Eye
                    },
                },
                {
                    name = "Bloodlord Mandokir",
                    id =  11382,
                    displayId = 11288,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 22637 }, -- Primal Hakkari Idol
                        { 19872 }, -- Swift Razzashi Raptor
                        { 20038 }, -- Mandokir's Sting
                        { 19867 }, -- Bloodlord's Defender
                        { 19866 }, -- Warblade of the Hakkari
                        { 19874 }, -- Halberd of Smiting
                        { 19878 }, -- Bloodsoaked Pauldrons
                        { 19870 }, -- Hakkari Loa Cloak
                        { 19869 }, -- Blooddrenched Grips
                        { 19895 }, -- Bloodtinged Kilt
                        { 19877 }, -- Animist's Leggings
                        { 19873 }, -- Overlord's Crimson Band
                        { 19863 }, -- Primalist's Seal
                        { 19893 }, -- Zanzil's Seal
                    },
                },
                {
                    name = "Gri'lek",
                    imageName = "Grizzle", -- TODO: boss image
                    id =  15082,
                    displayId = 8390,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19961 }, -- Gri'lek's Grinder
                        { 19962 }, -- Gri'lek's Carver
                        { 19939 }, -- Gri'lek's Blood
                    },
                },
                {
                    name = "Hazza'rah",
                    imageName = "Hazzarah", -- TODO: boss image
                    id =  15083,
                    displayId = 15267,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19967 }, -- Thoughtblighter
                        { 19968 }, -- Fiery Retributer
                        { 19942 }, -- Hazza'rah's Dream Thread
                    },
                },
                {
                    name = "Renataki",
                    id =  15084,
                    displayId = 15268,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19964 }, -- Renataki's Soul Conduit
                        { 19963 }, -- Pitchfork of Madness
                        { 19940 }, -- Renataki's Tooth
                    },
                },
                {
                    name = "Wushoolay",
                    imageName = "Shadowpriest Sezzizz", -- TODO: boss image
                    id =  15085,
                    displayId = 15269,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19993 }, -- Hoodoo Hunting Bow
                        { 19965 }, -- Wushoolay's Poker
                        { 19941 }, -- Wushoolay's Mane
                    },
                },
                {
                    name = "Gahz'ranka",
                    imageName = "Gahzrilla", -- TODO: boss image
                    id =  15114,
                    displayId = 15288,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19945 }, -- Foror's Eyepatch
                        { 19944 }, -- Nat Pagle's Fish Terminator
                        { 19947 }, -- Nat Pagle's Broken Reel
                        { 19946 }, -- Tigule's Harpoon
                        { 22739 }, -- Tome of Polymorph: Turtle
                    },
                },
                {
                    name = "High Priest Thekal",
                    imageName = "Default", -- TODO: boss image
                    id =  14509,
                    displayId = 15216,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 19902 }, -- Swift Zulian Tiger
                        { 19897 }, -- Betrayer's Boots
                        { 19896 }, -- Thekal's Grasp
                        { 19899 }, -- Ritualistic Legguards
                        { 20260 }, -- Seafury Leggings
                        { 20266 }, -- Peacekeeper Leggings
                        { 19898 }, -- Seal of Jin
                        { 19901 }, -- Zulian Slicer
                    },
                },
                {
                    name = "High Priestess Arlokk",
                    imageName = "Default", -- TODO: boss image
                    id =  14515,
                    displayId = 15218,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 19910 }, -- Arlokk's Grasp
                        { 19909 }, -- Will of Arlokk
                        { 19913 }, -- Bloodsoaked Greaves
                        { 19912 }, -- Overlord's Onyx Band
                        { 19922 }, -- Arlokk's Hoodoo Stick
                        { 19914 }, -- Panther Hide Sack
                    },
                },
                {
                    name = "Jin'do the Hexxer",
                    imageName= "Jindo the Godbreaker",
                    id =  11380,
                    displayId = 11311,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19721 }, -- Primal Hakkari Shawl
                        { 19724 }, -- Primal Hakkari Aegis
                        { 19723 }, -- Primal Hakkari Kossack
                        { 19722 }, -- Primal Hakkari Tabard
                        { 19717 }, -- Primal Hakkari Armsplint
                        { 19716 }, -- Primal Hakkari Bindings
                        { 19718 }, -- Primal Hakkari Stanchion
                        { 19719 }, -- Primal Hakkari Girdle
                        { 19720 }, -- Primal Hakkari Sash
                        { 22637 }, -- Primal Hakkari Idol
                        { 19885 }, -- Jin'do's Evil Eye
                        { 19891 }, -- Jin'do's Bag of Whammies
                        { 19890 }, -- Jin'do's Hexxer
                        { 19884 }, -- Jin'do's Judgement
                        { 19886 }, -- The Hexxer's Cover
                        { 19875 }, -- Bloodstained Coif
                        { 19888 }, -- Overlord's Embrace
                        { 19929 }, -- Bloodtinged Gloves
                        { 19894 }, -- Bloodsoaked Gauntlets
                        { 19889 }, -- Blooddrenched Leggings
                        { 19887 }, -- Bloodstained Legplates
                        { 19892 }, -- Animist's Boots
                    },
                },
                {
                    name = "Hakkar",
                    imageName = "Default", -- TODO: boss image
                    id =  14834,
                    displayId = 15295,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 19857 }, -- Cloak of Consumption
                        { 20257 }, -- Seafury Gauntlets
                        { 20264 }, -- Peacekeeper Gauntlets
                        { 19855 }, -- Bloodsoaked Legplates
                        { 19876 }, -- Soul Corrupter's Necklace
                        { 19856 }, -- The Eye of Hakkar
                        { 19802 }, -- Heart of Hakkar
                        { 19861 }, -- Touch of Chaos
                        { 19853 }, -- Gurubashi Dwarf Destroyer
                        { 19862 }, -- Aegis of the Blood God
                        { 19864 }, -- Bloodcaller
                        { 19865 }, -- Warblade of the Hakkari
                        { 19866 }, -- Warblade of the Hakkari
                        { 19852 }, -- Ancient Hakkari Manslayer
                        { 19859 }, -- Fang of the Faceless
                        { 19854 }, -- Zin'rokh, Destroyer of Worlds
                    },
                },
            }
        },
        {
            name = "RuinsOfAhnQiraj",
            id = 509,
            recommended = {60,60},
            lore = "During the final hours of the War of the Shifting Sands, the combined forces of the night elves and the four dragonflights drove the battle to the very heart of the qiraji empire, to the fortress city of Ahn'Qiraj. Yet at the city gates, the armies of Kalimdor encountered a concentration of silithid war drones more massive than any they had encountered before. Ultimately the silithid and their qiraji masters were not defeated, but merely imprisoned inside a magical barrier, and the war left the cursed city in ruins. A thousand years have passed since that day, but the qiraji forces have not been idle. A new and terrible army has been spawned from the hives, and the ruins of Ahn'Qiraj are teeming once again with swarming masses of silithid and qiraji. This threat must be eliminated, or else all of Azeroth may fall before the terrifying might of the new qiraji army.",
            bosses = {
                {
                    name = "Kurinnaxx",
                    id = 15348,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21499 }, -- Vestments of the Shifting Sands
                        { 21498 }, -- Qiraji Sacrificial Dagger
                        { 21502 }, -- Sand Reaver Wristguards
                        { 21501 }, -- Toughened Silithid Hide Gloves
                        { 21500 }, -- Belt of the Inquisition
                        { 21503 }, -- Belt of the Sand Reaver
                        { 20885 }, -- Qiraji Martial Drape
                        { 20889 }, -- Qiraji Regal Drape
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                    },
                },
                {
                    name = "General Rajaxx",
                    id = 15341,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21493 }, -- Boots of the Vanguard
                        { 21492 }, -- Manslayer of the Qiraji
                        { 21496 }, -- Bracers of Qiraji Command
                        { 21494 }, -- Southwind's Grasp
                        { 21495 }, -- Legplates of the Qiraji Command
                        { 21497 }, -- Boots of the Qiraji General
                        { 21810 }, -- Treads of the Wandering Nomad
                        { 21809 }, -- Fury of the Forgotten Swarm
                        { 21806 }, -- Gavel of Qiraji Authority
                        { 20885 }, -- Qiraji Martial Drape
                        { 20889 }, -- Qiraji Regal Drape
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                    },
                },
                {
                    name = "Moam",
                    id = 15340,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21472 }, -- Dustwind Turban
                        { 21467 }, -- Thick Silithid Chestguard
                        { 21479 }, -- Gauntlets of the Immovable
                        { 21471 }, -- Talon of Furious Concentration
                        { 21455 }, -- Southwind Helm
                        { 21468 }, -- Mantle of Maz'Nadir
                        { 21474 }, -- Chitinous Shoulderguards
                        { 21470 }, -- Cloak of the Savior
                        { 21469 }, -- Gauntlets of Southwind
                        { 21476 }, -- Obsidian Scaled Leggings
                        { 21475 }, -- Legplates of the Destroyer
                        { 21477 }, -- Ring of Fury
                        { 21473 }, -- Eye of Moam
                        { 20890 }, -- Qiraji Ornate Hilt
                        { 20886 }, -- Qiraji Spiked Hilt
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                        { 22220 }, -- Plans: Black Grasp of the Destroyer
                    },
                },
                {
                    name = "Buru the Gorger",
                    id = 15370,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21487 }, -- Slimy Scaled Gauntlets HORDE
                        { 21486 }, -- Gloves of the Swarm ALLIANCE
                        { 21485 }, -- Buru's Skull Fragment
                        { 21491 }, -- Scaled Bracers of the Gorger
                        { 21489 }, -- Quicksand Waders
                        { 21490 }, -- Slime Kickers
                        { 21488 }, -- Fetish of Chitinous Spikes
                        { 20890 }, -- Qiraji Ornate Hilt
                        { 20886 }, -- Qiraji Spiked Hilt
                        { 20885 }, -- Qiraji Martial Drape
                        { 20889 }, -- Qiraji Regal Drape
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                    },
                },
                {
                    name = "Ayamiss the Hunter",
                    id = 15369,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21479 }, -- Gauntlets of the Immovable
                        { 21478 }, -- Bow of Taut Sinew
                        { 21466 }, -- Stinger of Ayamiss
                        { 21484 }, -- Helm of Regrowth
                        { 21480 }, -- Scaled Silithid Gauntlets
                        { 21482 }, -- Boots of the Fiery Sands
                        { 21481 }, -- Boots of the Desert Protector
                        { 21483 }, -- Ring of the Desert Winds
                        { 20890 }, -- Qiraji Ornate Hilt
                        { 20886 }, -- Qiraji Spiked Hilt
                        { 20885 }, -- Qiraji Martial Drape
                        { 20889 }, -- Qiraji Regal Drape
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                    },
                },
                {
                    name = "Ossirian the Unscarred",
                    id = 15339,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21460 }, -- Helm of Domination
                        { 21454 }, -- Runic Stone Shoulders HORDE
                        { 21453 }, -- Mantle of the Horusath ALLIANCE
                        { 21456 }, -- Sandstorm Cloak
                        { 21464 }, -- Shackles of the Unscarred
                        { 21457 }, -- Bracers of Brutality
                        { 21462 }, -- Gloves of Dark Wisdom
                        { 21458 }, -- Gauntlets of New Life
                        { 21463 }, -- Ossirian's Binding
                        { 21461 }, -- Leggings of the Black Blizzard
                        { 21459 }, -- Crossbow of Imminent Doom
                        { 21715 }, -- Sand Polished Hammer
                        { 21452 }, -- Staff of the Ruins
                        { 20890 }, -- Qiraji Ornate Hilt
                        { 20886 }, -- Qiraji Spiked Hilt
                        { 20888 }, -- Qiraji Ceremonial Ring
                        { 20884 }, -- Qiraji Magisterial Ring
                        { 21220 }, -- Head of Ossirian the Unscarred
                    },
                },
            }
        },
        {
            name = "TempleOfAhnQiraj",
            id = 531,
            recommended = {60,60},
            lore = "At the heart of Ahn'Qiraj lies an ancient temple complex. Built in the time before recorded history, it is both a monument to unspeakable gods and a massive breeding ground for the qiraji army. Since the War of the Shifting Sands ended a thousand years ago, the Twin Emperors of the qiraji empire have been trapped inside their temple, barely contained behind the magical barrier erected by the bronze dragon Anachronos and the night elves.\nNow that the Scepter of the Shifting Sands has been reassembled and the seal has been broken, the way into the inner sanctum of Ahn'Qiraj is open. Beyond the crawling madness of the hives, beneath the Temple of Ahn'Qiraj, legions of qiraji prepare for invasion. They must be stopped at all costs before they can unleash their voracious insectoid armies on Kalimdor once again, and a second War of the Shifting Sands breaks loose!",
            bosses = {
                {
                    name = "The Prophet Skeram",
                    id = 15263,
                    level = DJ.BOSS_LEVEL,
                    lore = "The Prophet Skeram is an important religious leader in Ahn'Qiraj, and author of The Prophecy of C'Thun.",
                    items = {
                        { 21699 }, -- Barrage Shoulders
                        { 21814 }, -- Breastplate of Annihilation
                        { 21708 }, -- Beetle Scaled Wristguards
                        { 21698 }, -- Leggings of Immersion
                        { 21705 }, -- Boots of the Fallen Prophet
                        { 21704 }, -- Boots of the Redeemed Prophecy
                        { 21706 }, -- Boots of the Unwavering Will
                        { 21702 }, -- Amulet of Foul Warding
                        { 21700 }, -- Pendant of the Qiraji Guardian
                        { 21701 }, -- Cloak of Concentrated Hatred
                        { 21707 }, -- Ring of Swarming Thought
                        { 21703 }, -- Hammer of Ji'zhi
                        { 21128 }, -- Staff of the Qiraji Prophets
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                        { 22222 }, -- Plans: Thick Obsidian Breastplate
                    },
                },
                {
                    name = "Silithid Royalty",
                    id = 15543,
                    ids = {15543, 15544, 15511},
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21693 }, -- Guise of the Devourer
                        { 21694 }, -- Ternary Mantle
                        { 21697 }, -- Cape of the Trinity
                        { 21696 }, -- Robes of the Triumvirate
                        { 21692 }, -- Triad Girdle
                        { 21695 }, -- Angelista's Touch
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                        
                        -- Kri
                        { 21680 }, -- Vest of Swift Execution
                        { 21681 }, -- Ring of the Devoured
                        { 21685 }, -- Petrified Scarab
                        { 21603 }, -- Wand of Qiraji Nobility
                        
                        -- Vem
                        { 21690 }, -- Angelista's Charm
                        { 21689 }, -- Gloves of Ebru
                        { 21691 }, -- Ooze-ridden Gauntlets
                        { 21688 }, -- Boots of the Fallen Hero
                        
                        -- Yauj
                        { 21686 }, -- Mantle of Phrenic Power
                        { 21684 }, -- Mantle of the Desert's Fury
                        { 21683 }, -- Mantle of the Desert Crusade
                        { 21682 }, -- Bile-Covered Gauntlets
                        { 21687 }, -- Ukko's Ring of Darkness
                    },
                },
                {
                    name = "Battleguard Sartura",
                    id = 15516,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21669 }, -- Creeping Vine Helm
                        { 21678 }, -- Necklace of Purity
                        { 21671 }, -- Robes of the Battleguard
                        { 21672 }, -- Gloves of Enforcement
                        { 21674 }, -- Gauntlets of Steadfast Determination
                        { 21675 }, -- Thick Qirajihide Belt
                        { 21676 }, -- Leggings of the Festering Swarm
                        { 21668 }, -- Scaled Leggings of Qiraji Fury
                        { 21667 }, -- Legplates of Blazing Light
                        { 21648 }, -- Recomposed Boots
                        { 21670 }, -- Badge of the Swarmguard
                        { 21666 }, -- Sartura's Might
                        { 21673 }, -- Silithid Claw
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                    },
                },
                {
                    name = "Fankriss the Unyielding",
                    id = 15510,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21665 }, -- Mantle of Wicked Revenge
                        { 21639 }, -- Pauldrons of the Unrelenting
                        { 21627 }, -- Cloak of Untold Secrets
                        { 21663 }, -- Robes of the Guardian Saint
                        { 21652 }, -- Silithid Carapace Chestguard
                        { 21651 }, -- Scaled Sand Reaver Leggings
                        { 21645 }, -- Hive Tunneler's Boots
                        { 21650 }, -- Ancient Qiraji Ripper
                        { 21635 }, -- Barb of the Sand Reaver
                        { 21664 }, -- Barbed Choker
                        { 21647 }, -- Fetish of the Sand Reaver
                        { 22402 }, -- Libram of Grace
                        { 22396 }, -- Totem of Life
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                    },
                },
                {
                    name = "Viscidus",
                    id = 15299,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21624 }, -- Gauntlets of Kalimdor
                        { 21623 }, -- Gauntlets of the Righteous Champion
                        { 21626 }, -- Slime-coated Leggings
                        { 21622 }, -- Sharpened Silithid Femur
                        { 21677 }, -- Ring of the Qiraji Fury
                        { 21625 }, -- Scarab Brooch
                        { 22399 }, -- Idol of Health
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                        { 20928 }, -- Qiraji Bindings of Command
                        { 20932 }, -- Qiraji Bindings of Dominance
                    },
                },
                {
                    name = "Princess Huhuran",
                    id = 15509,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21621 }, -- Cloak of the Golden Hive
                        { 21618 }, -- Hive Defiler Wristguards
                        { 21619 }, -- Gloves of the Messiah
                        { 21617 }, -- Wasphide Gauntlets
                        { 21620 }, -- Ring of the Martyr
                        { 21616 }, -- Huhuran's Stinger
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                        { 20928 }, -- Qiraji Bindings of Command
                        { 20932 }, -- Qiraji Bindings of Dominance
                    },
                },
                {
                    name = "Twin Emperors",
                    id = 15275,
                    ids = {15275, 15276},
                    level = DJ.BOSS_LEVEL,
                    items = {
                        -- Vek'lor
                        { 20930 }, -- Vek'lor's Diadem
                        { 21602 }, -- Qiraji Execution Bracers
                        { 21599 }, -- Vek'lor's Gloves of Devastation
                        { 21598 }, -- Royal Qiraji Belt
                        { 21600 }, -- Boots of Epiphany
                        { 21601 }, -- Ring of Emperor Vek'lor
                        { 21597 }, -- Royal Scepter of Vek'lor
                        { 20735 }, -- Formula: Enchant Cloak - Subtlety
                        { 21232 }, -- Imperial Qiraji Armaments
                        -- Vek'nilash
                        { 20926 }, -- Vek'nilash's Circlet
                        { 21608 }, -- Amulet of Vek'nilash
                        { 21604 }, -- Bracelets of Royal Redemption
                        { 21605 }, -- Gloves of the Hidden Temple
                        { 21609 }, -- Regenerating Belt of Vek'nilash
                        { 21607 }, -- Grasp of the Fallen Emperor
                        { 21606 }, -- Belt of the Fallen Emperor
                        { 21679 }, -- Kalimdor's Revenge
                        { 20726 }, -- Formula: Enchant Gloves - Threat
                        { 21237 }, -- Imperial Qiraji Regalia
                    },
                },
                {
                    name = "Ouro",
                    id = 15517,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 21615 }, -- Don Rigoberto's Lost Hat
                        { 21611 }, -- Burrower Bracers
                        { 23558 }, -- The Burrower's Shell
                        { 23570 }, -- Jom Gabbar
                        { 21610 }, -- Wormscale Blocker
                        { 23557 }, -- Larvae of the Great Worm
                        { 21237 }, -- Imperial Qiraji Regalia
                        { 21232 }, -- Imperial Qiraji Armaments
                        { 20927 }, -- Ouro's Intact Hide
                        { 20931 }, -- Skin of the Great Sandworm
                    },
                },
                {
                    name = "C'Thun",
                    imageName = "CThun",
                    id = 15727,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22732 }, -- Mark of C'Thun
                        { 21583 }, -- Cloak of Clarity
                        { 22731 }, -- Cloak of the Devoured
                        { 22730 }, -- Eyestalk Waist Cord
                        { 21582 }, -- Grasp of the Old God
                        { 21586 }, -- Belt of Never-ending Agony
                        { 21585 }, -- Dark Storm Gauntlets
                        { 21581 }, -- Gauntlets of Annihilation
                        { 21596 }, -- Ring of the Godslayer
                        { 21579 }, -- Vanquished Tentacle of C'Thun
                        { 21839 }, -- Scepter of the False Prophet
                        { 21126 }, -- Death's Sting
                        { 21134 }, -- Dark Edge of Insanity
                        { 20929 }, -- Carapace of the Old God
                        { 20933 }, -- Husk of the Old God
                        { 21221 }, -- Eye of C'Thun
                        { 22734 }, -- Base of Atiesh
                    },
                },
            }
        },
        {
            name = "Naxxramas",
            id = 533,
            recommended = {60,60},
            lore = "Years ago, the crypt lord Anub'arak led an army of undead warriors into the ancient nerubian ziggurat now known as Naxxramas. The Scourge forces overran the citadel, and under the will of the Lich King its corridors were transformed into a potent war machine. Dark magic tore the fortress from its subterranean home and lifted it into the sky. Hidden behind a thick layer of clouds, Naxxramas grew in strength. At the Lich King's bidding, the burgeoning wrath within the necropolis was unleashed upon the world.",
            bosses = {
                -- The Arachnid Quarter
                {
                    name = "Anub'Rekhan",
                    imageName = "Anubrekhan",
                    id = 15956,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22369 }, -- Desecrated Bindings
                        { 22362 }, -- Desecrated Wristguards
                        { 22355 }, -- Desecrated Bracers
                        { 22935 }, -- Touch of Frost
                        { 22938 }, -- Cryptfiend Silk Cloak
                        { 22936 }, -- Wristguards of Vengeance
                        { 22939 }, -- Band of Unanswered Prayers
                        { 22937 }, -- Gem of Nerubis
                    },
                },
                {
                    name = "Grand Widow Faerlina",
                    id = 15953,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22369 }, -- Desecrated Bindings
                        { 22362 }, -- Desecrated Wristguards
                        { 22355 }, -- Desecrated Bracers
                        { 22943 }, -- Malice Stone Pendant
                        { 22941 }, -- Polar Shoulder Pads
                        { 22940 }, -- Icebane Pauldrons
                        { 22942 }, -- The Widow's Embrace
                        { 22806 }, -- Widow's Remorse
                    },
                },
                {
                    name = "Maexxna",
                    id = 15952,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22371 }, -- Desecrated Gloves
                        { 22364 }, -- Desecrated Handguards
                        { 22357 }, -- Desecrated Gauntlets
                        { 22947 }, -- Pendant of Forgotten Names
                        { 23220 }, -- Crystal Webbed Robe
                        { 22954 }, -- Kiss of the Spider
                        { 22807 }, -- Wraith Blade
                        { 22804 }, -- Maexxna's Fang
                    },
                },
                -- The Plague Quarter
                {
                    name = "Noth the Plaguebringer",
                    id = 15954,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22370 }, -- Desecrated Belt
                        { 22363 }, -- Desecrated Girdle
                        { 22356 }, -- Desecrated Waistguard
                        { 23030 }, -- Cloak of the Scourge
                        { 23031 }, -- Band of the Inevitable
                        { 23028 }, -- Hailstone Band
                        { 23029 }, -- Noth's Frigid Heart
                        { 23006 }, -- Libram of Light
                        { 23005 }, -- Totem of Flowing Water
                        { 22816 }, -- Hatchet of Sundered Bone
                    },
                },
                {
                    name = "Heigan the Unclean",
                    id = 15936,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22370 }, -- Desecrated Belt
                        { 22363 }, -- Desecrated Girdle
                        { 22356 }, -- Desecrated Waistguard
                        { 23035 }, -- Preceptor's Hat
                        { 23033 }, -- Icy Scale Coif
                        { 23019 }, -- Icebane Helmet
                        { 23036 }, -- Necklace of Necropsy
                        { 23068 }, -- Legplates of Carnage
                    },
                },
                {
                    name = "Loatheb",
                    id = 16011,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22366 }, -- Desecrated Leggings
                        { 22359 }, -- Desecrated Legguards
                        { 22352 }, -- Desecrated Legplates
                        { 23038 }, -- Band of Unnatural Forces
                        { 23037 }, -- Ring of Spiritual Fervor
                        { 23042 }, -- Loatheb's Reflection
                        { 23039 }, -- The Eye of Nerub
                        { 22800 }, -- Brimstone Staff
                    },
                },
                -- The Military Quarter
                {
                    name = "Instructor Razuvious",
                    id = 16061,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22372 }, -- Desecrated Sandals
                        { 22365 }, -- Desecrated Boots
                        { 22358 }, -- Desecrated Sabatons
                        { 23017 }, -- Veil of Eclipse
                        { 23219 }, -- Girdle of the Mentor
                        { 23018 }, -- Signet of the Fallen Defender
                        { 23004 }, -- Idol of Longevity
                        { 23009 }, -- Wand of the Whispering Dead
                        { 23014 }, -- Iblis, Blade of the Fallen Seraph
                    },
                },
                {
                    name = "Gothik the Harvester",
                    id = 16060,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22372 }, -- Desecrated Sandals
                        { 22365 }, -- Desecrated Boots
                        { 22358 }, -- Desecrated Sabatons
                        { 23032 }, -- Glacial Headdress
                        { 23020 }, -- Polar Helmet
                        { 23023 }, -- Sadist's Collar
                        { 23021 }, -- The Soul Harvester's Bindings
                        { 23073 }, -- Boots of Displacement
                    },
                },
                {
                    name = "The Four Horsemen",
                    imageName = "Four Horseman",
                    id = 16064,
                    ids = {16064, 16065, 30549, 16063},
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22351 }, -- Desecrated Robe
                        { 22350 }, -- Desecrated Tunic
                        { 22349 }, -- Desecrated Breastplate
                        { 23071 }, -- Leggings of Apocalypse
                        { 23025 }, -- Seal of the Damned
                        { 23027 }, -- Warmth of Forgiveness
                        { 22811 }, -- Soulstring
                        { 22809 }, -- Maul of the Redeemed Crusader
                        { 22691 }, -- Corrupted Ashbringer
                    },
                },
                -- The Construct Quarter
                {
                    name = "Patchwerk",
                    id = 16028,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22368 }, -- Desecrated Shoulderpads
                        { 22361 }, -- Desecrated Spaulders
                        { 22354 }, -- Desecrated Pauldrons
                        { 22960 }, -- Cloak of Suturing
                        { 22961 }, -- Band of Reanimation
                        { 22820 }, -- Wand of Fates
                        { 22818 }, -- The Plague Bearer
                        { 22815 }, -- Severance
                    },
                },
                {
                    name = "Grobbulus",
                    id = 15931,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22368 }, -- Desecrated Shoulderpads
                        { 22361 }, -- Desecrated Spaulders
                        { 22354 }, -- Desecrated Pauldrons
                        { 22968 }, -- Glacial Mantle
                        { 22967 }, -- Icy Scale Spaulders
                        { 22810 }, -- Toxin Injector
                        { 22803 }, -- Midnight Haze
                        { 22988 }, -- The End of Dreams
                    },
                },
                {
                    name = "Gluth",
                    id = 15932,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22983 }, -- Rime Covered Mantle
                        { 22981 }, -- Gluth's Missing Collar
                        { 22994 }, -- Digested Hand of Power
                        { 23075 }, -- Death's Bargain
                        { 22813 }, -- Claymore of Unholy Might
                        { 22368 }, -- Desecrated Shoulderpads
                        { 22369 }, -- Desecrated Bindings
                        { 22370 }, -- Desecrated Belt
                        { 22372 }, -- Desecrated Sandals
                        { 22361 }, -- Desecrated Spaulders
                        { 22362 }, -- Desecrated Wristguards
                        { 22363 }, -- Desecrated Girdle
                        { 22365 }, -- Desecrated Boots
                        { 22354 }, -- Desecrated Pauldrons
                        { 22355 }, -- Desecrated Bracers
                        { 22356 }, -- Desecrated Waistguard
                        { 22358 }, -- Desecrated Sabatons
                    },
                },
                {
                    name = "Thaddius",
                    id = 15928,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 22726 }, -- Splinter of Atiesh
                        { 22727 }, -- Frame of Atiesh
                        { 22367 }, -- Desecrated Circlet
                        { 22360 }, -- Desecrated Headpiece
                        { 22353 }, -- Desecrated Helmet
                        { 23000 }, -- Plated Abomination Ribcage
                        { 23070 }, -- Leggings of Polarity
                        { 23001 }, -- Eye of Diminution
                        { 22808 }, -- The Castigator
                        { 22801 }, -- Spire of Twilight
                    },
                },
                -- Frostwyrm Lair
                {
                    name = "Sapphiron",
                    id = 15989,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 23050 }, -- Cloak of the Necropolis
                        { 23045 }, -- Shroud of Dominion
                        { 23040 }, -- Glyph of Deflection
                        { 23047 }, -- Eye of the Dead
                        { 23041 }, -- Slayer's Crest
                        { 23046 }, -- The Restrained Essence of Sapphiron
                        { 23049 }, -- Sapphiron's Left Eye
                        { 23048 }, -- Sapphiron's Right Eye
                        { 23043 }, -- The Face of Death
                        { 23242 }, -- Claw of the Frost Wyrm
                        { 23549 }, -- Fortitude of the Scourge
                        { 23548 }, -- Might of the Scourge
                        { 23545 }, -- Power of the Scourge
                        { 23547 }, -- Resilience of the Scourge
                    },
                },
                {
                    name = "Kel'Thuzad",
                    imageName = "Kelthuzad",
                    id = 15990,
                    level = DJ.BOSS_LEVEL,
                    items = {
                        { 23057 }, -- Gem of Trapped Innocents
                        { 23053 }, -- Stormrage's Talisman of Seething
                        { 22812 }, -- Nerubian Slavemaker
                        { 22821 }, -- Doomfinger
                        { 22819 }, -- Shield of Condemnation
                        { 22802 }, -- Kingsfall
                        { 23056 }, -- Hammer of the Twisting Nether
                        { 23054 }, -- Gressil, Dawn of Ruin
                        { 23577 }, -- The Hungering Cold
                        { 22798 }, -- Might of Menethil
                        { 22799 }, -- Soulseeker
                        { 22520 }, -- The Phylactery of Kel'Thuzad
                        { 23061 }, -- Ring of Faith
                        { 23062 }, -- Frostfire Ring
                        { 23063 }, -- Plagueheart Ring
                        { 23060 }, -- Bonescythe Ring
                        { 23064 }, -- Ring of the Dreamwalker
                        { 23067 }, -- Ring of the Cryptstalker
                        { 23065 }, -- Ring of the Earthshatterer
                        { 23066 }, -- Ring of Redemption
                        { 23059 }, -- Ring of the Dreadnaught
                        { 22733 }, -- Staff Head of Atiesh
                    },
                },
            }
        }
    }
}

function DJ.Database:GetInstanceById(id)
    for i, instance in next, DJ.Database.Dungeons do
        if instance.id == id then
            return instance
        end
    end
    for i, instance in next, DJ.Database.Raids do
        if instance.id == id then
            return instance
        end
    end
end

function DJ.Database:GetBossById(id)
    for i, instance in next, DJ.Database.Dungeons do
        if instance.bosses and #instance.bosses > 0 then
            for _, boss in ipairs(instance.bosses) do
                if id == boss.id then
                    return boss
                end
            end
        end
    end
    for i, instance in next, DJ.Database.Raids do
        if instance.bosses and #instance.bosses > 0 then
            for _, boss in ipairs(instance.bosses) do
                if id == boss.id then
                    return boss
                end
            end
        end
    end
end

function DJ.Database:IsBossInInstance(name, instance)
    if instance.bosses and #instance.bosses > 0 then
        for _, boss in ipairs(instance.bosses) do
            if name == boss.name then
                return true
            end
        end
    end

    return false
end

function DJ.Database:BossDropsItem(boss, itemId)
    for i, item in ipairs(boss.items) do
        if item[1] == itemId then
            return true
        end
    end

    return false
end

function DJ.Database:GetBossesThatDropItem(itemId, instanceId)
    local instance = DJ.Database:GetInstanceById(instanceId)
    local bosses = {}
    if instance and instance.bosses then
        for i, boss in next, instance.bosses do
            if boss.items then
                for j, item in ipairs(boss.items) do
                    if item[1] == itemId then
                        table.insert(bosses, boss)
                        break
                    end
                end
            end
        end
    end
    return bosses
end

for _, instance in next, DJ.Database.Dungeons do
    instance.title = GetRealZoneText(instance.id)
    instance.isDungeon = true
end

for _, instance in next, DJ.Database.Raids do
    instance.title = GetRealZoneText(instance.id)
    instance.isRaid = true
end