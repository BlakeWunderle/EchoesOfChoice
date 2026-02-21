using System;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Common
{
    public abstract class BaseFighter
    {
        public BaseFighter()
        { }

        public BaseFighter ( BaseFighter fighter )
        {
            this.CharacterName = fighter.CharacterName;
            this.CharacterType = fighter.CharacterType;
            this.IsUserControlled = false;
            this.Level = fighter.Level;
            this.Health = fighter.Health;
            this.MaxHealth = fighter.MaxHealth;
            this.Mana = fighter.Mana;
            this.MaxMana = fighter.MaxMana;
            this.PhysicalAttack = fighter.PhysicalAttack;
            this.PhysicalDefense = fighter.PhysicalDefense;
            this.MagicAttack = fighter.MagicAttack;
            this.MagicDefense = fighter.MagicDefense;
            this.Speed = fighter.Speed;
            this.CritChance = fighter.CritChance;
            this.CritDamage = fighter.CritDamage;
            this.DodgeChance = fighter.DodgeChance;
            this.Abilities = fighter.Abilities;
        }

        public Random random = new Random();
        public string CharacterName { get; set; }
        public string CharacterType { get; set; }
        public bool IsUserControlled { get; set; }
        public int Level { get; protected set; }
        public int Health { get; set; }
        public int MaxHealth { get; set; }
        public int Mana { get; set; }
        public int MaxMana { get; set; }
        public int PhysicalAttack { get; set; }
        public int PhysicalDefense { get; set; }
        public int MagicAttack { get; set; }
        public int MagicDefense { get; set; }
        public int Speed { get; set; }
        public int CritChance { get; set; }
        public int CritDamage { get; set; }
        public int DodgeChance { get; set; }
        public int TurnCalculation { get; set; }
        public List<Ability> Abilities { get; set; }
        public abstract void IncreaseLevel();

        protected int Stat(int baseMin, int baseMax, int growthMin, int growthMax, int baseLevel = 1)
        {
            int lvl = Level - baseLevel;
            return random.Next(baseMin + lvl * growthMin, baseMax + lvl * (growthMax - 1));
        }
        public abstract BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem);
        public void KeepStatsOnUpgrade(BaseFighter fighter)
        {
            this.Level = fighter.Level;
            this.Health = fighter.Health;
            this.MaxHealth = fighter.MaxHealth;
            this.Mana = fighter.Mana;
            this.MaxMana = fighter.MaxMana;
            this.PhysicalAttack = fighter.PhysicalAttack;
            this.PhysicalDefense = fighter.PhysicalDefense;
            this.MagicAttack = fighter.MagicAttack;
            this.MagicDefense = fighter.MagicDefense;
            this.Speed = fighter.Speed;
            this.CharacterName = fighter.CharacterName;
            this.IsUserControlled = fighter.IsUserControlled;
            ApplyUpgradeBonuses();
        }

        protected virtual void ApplyUpgradeBonuses() { }
        public void ShowStats()
        {
            Console.WriteLine($"Character: {CharacterName}");
            Console.WriteLine($"Class: {CharacterType}");
            Console.WriteLine($"Health: {Health}/{MaxHealth}");
            Console.WriteLine($"Mana: {Mana}/{MaxMana}");
            Console.WriteLine($"Physical Attack: {PhysicalAttack}");
            Console.WriteLine($"Physical Defense: {PhysicalDefense}");
            Console.WriteLine($"Magic Attack: {MagicAttack}");
            Console.WriteLine($"Magic Defense: {MagicDefense}");
            Console.WriteLine($"Speed: {Speed}");
            Console.WriteLine($"Crit Chance: {CritChance}/10");
            Console.WriteLine($"Crit Damage: {CritDamage}");
            Console.WriteLine($"Dodge Chance: {DodgeChance}/10");
        }

        public FighterSaveData ToSaveData()
        {
            return new FighterSaveData
            {
                ClassId = GetType().Name,
                CharacterName = CharacterName,
                IsUserControlled = IsUserControlled,
                Level = Level,
                MaxHealth = MaxHealth,
                MaxMana = MaxMana,
                PhysicalAttack = PhysicalAttack,
                PhysicalDefense = PhysicalDefense,
                MagicAttack = MagicAttack,
                MagicDefense = MagicDefense,
                Speed = Speed,
                CritChance = CritChance,
                CritDamage = CritDamage,
                DodgeChance = DodgeChance
            };
        }

        public void ApplySaveData(FighterSaveData data)
        {
            CharacterName = data.CharacterName;
            IsUserControlled = data.IsUserControlled;
            Level = data.Level;
            MaxHealth = data.MaxHealth;
            Health = data.MaxHealth;
            MaxMana = data.MaxMana;
            Mana = data.MaxMana;
            PhysicalAttack = data.PhysicalAttack;
            PhysicalDefense = data.PhysicalDefense;
            MagicAttack = data.MagicAttack;
            MagicDefense = data.MagicDefense;
            Speed = data.Speed;
            CritChance = data.CritChance;
            CritDamage = data.CritDamage;
            DodgeChance = data.DodgeChance;
        }

        public List<ModifiedStat> ModifiedStats = new List<ModifiedStat>();

        public List<UpgradeItemEnum> UpgradeItems { get; set; }

        public abstract BaseFighter Clone();
    }
}
