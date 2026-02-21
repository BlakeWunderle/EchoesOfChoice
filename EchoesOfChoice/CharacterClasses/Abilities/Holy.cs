using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Holy : Ability
    {
        public Holy()
        {
            Name = "Holy";
            FlavorText = "Bring forth the light!";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
