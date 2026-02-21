using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class FrostWyrmling : BaseFighter
    {
        public FrostWyrmling(int level = 6)
        {
            Level = level;
            Health = Stat(115, 125, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(26, 30, 0, 0, 6);
            PhysicalDefense = Stat(20, 24, 0, 0, 6);
            MagicAttack = Stat(17, 21, 0, 0, 6);
            MagicDefense = Stat(16, 20, 0, 0, 6);
            Speed = Stat(16, 20, 0, 0, 6);
            Abilities = new List<Ability>() { new Claw(), new TailStrike(), new Riptide() };
            CharacterType = "FrostWyrmling";
            Mana = Stat(20, 24, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public FrostWyrmling(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new FrostWyrmling(this);
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
