using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Dragon : BaseFighter
    {
        public Dragon(int level = 17)
        {
            Level = level;
            Health = Stat(402, 442, 10, 14, 17);
            MaxHealth = Health;
            PhysicalAttack = Stat(40, 48, 3, 5, 17);
            PhysicalDefense = Stat(36, 42, 3, 5, 17);
            MagicAttack = Stat(61, 69, 4, 6, 17);
            MagicDefense = Stat(32, 38, 2, 4, 17);
            Speed = Stat(34, 40, 2, 4, 17);
            Abilities = new List<Ability>() { new DragonBreath(), new TailStrike(), new Roar() };
            CharacterType = "Dragon";
            Mana = Stat(42, 50, 3, 5, 17);
            MaxMana = Mana;
            CritChance = 28;
            CritDamage = 5;
            DodgeChance = 21;
        }

        public Dragon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Dragon(this);
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
