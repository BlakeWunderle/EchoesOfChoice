using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Demon : BaseFighter
    {
        public Demon(int level = 16)
        {
            Level = level;
            Health = Stat(320, 360, 8, 12, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(24, 30, 1, 3, 16);
            PhysicalDefense = Stat(30, 36, 2, 4, 16);
            MagicAttack = Stat(60, 68, 4, 6, 16);
            MagicDefense = Stat(34, 40, 2, 4, 16);
            Speed = Stat(34, 40, 2, 4, 16);
            Abilities = new List<Ability>() { new Brimstone(), new InfernalStrike(), new Dread() };
            CharacterType = "Demon";
            Mana = Stat(48, 56, 3, 5, 16);
            MaxMana = Mana;
            CritChance = 22;
            CritDamage = 4;
            DodgeChance = 25;
        }

        public Demon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Demon(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
