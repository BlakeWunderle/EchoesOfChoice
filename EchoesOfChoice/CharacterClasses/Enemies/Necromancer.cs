using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Necromancer : BaseFighter
    {
        public Necromancer(int level = 9)
        {
            Level = level;
            Health = Stat(103, 131, 5, 10, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(23, 33, 1, 3, 9);
            PhysicalDefense = Stat(24, 34, 2, 4, 9);
            MagicAttack = Stat(49, 63, 5, 8, 9);
            MagicDefense = Stat(26, 36, 2, 4, 9);
            Speed = Stat(28, 38, 2, 4, 9);
            Abilities = new List<Ability>() { new DeathTouch(), new Blight(), new Decay() };
            CharacterType = "Necromancer";
            Mana = Stat(48, 67, 4, 7, 9);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Necromancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Necromancer(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
