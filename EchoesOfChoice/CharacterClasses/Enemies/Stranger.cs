using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Stranger : BaseFighter
    {
        public Stranger(int level = 16)
        {
            Level = level;
            Health = Stat(582, 652, 16, 22, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(60, 68, 4, 6, 16);
            PhysicalDefense = Stat(34, 40, 2, 4, 16);
            MagicAttack = Stat(66, 76, 4, 7, 16);
            MagicDefense = Stat(36, 42, 2, 4, 16);
            Speed = Stat(38, 44, 2, 4, 16);
            Abilities = new List<Ability>() { new ShadowStrike(), new DarkPulse(), new VoidShield(), new Drain() };
            CharacterType = "Stranger";
            Mana = Stat(50, 58, 3, 5, 16);
            MaxMana = Mana;
            CritChance = 26;
            CritDamage = 5;
            DodgeChance = 24;
        }

        public Stranger(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Stranger(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 3);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(2, 3);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
