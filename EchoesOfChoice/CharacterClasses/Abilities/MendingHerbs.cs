using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class MendingHerbs : Ability
    {
        public MendingHerbs()
        {
            Name = "Mending Herbs";
            FlavorText = "Apply a poultice of healing herbs to mend wounds.";
            ModifiedStat = StatEnum.Health;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
